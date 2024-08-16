# syntax = docker/dockerfile:1

# 確保 RUBY_VERSION 與 .ruby-version 和 Gemfile 中的版本一致
ARG RUBY_VERSION=3.2.0
FROM ruby:$RUBY_VERSION-slim AS base

# Rails 應用所在的目錄
WORKDIR /rails

# 設置生產環境
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# 臨時構建階段以減少最終映像大小
FROM base AS build

# 安裝構建 gems 和 Yarn 所需的依賴包
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libvips pkg-config curl && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn@1.22.19

# 安裝應用程式的 gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# 安裝 JavaScript 依賴
COPY package.json yarn.lock ./

# 保留鎖定檔案，並使用網路並發選項解決 yarn 安裝問題
RUN rm -rf node_modules && yarn install --network-concurrency 1 --network-timeout 600000

# 複製應用程式代碼
COPY . .

# 預編譯 bootsnap 代碼以加快啟動速度
RUN bundle exec bootsnap precompile app/ lib/

# 使用臨時的 SECRET_KEY_BASE 預編譯生產資源
RUN SECRET_KEY_BASE=dummy_secret_key_base ./bin/rails assets:precompile

# 最終映像的部署階段
FROM base

# 安裝部署所需的軟體包
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libvips postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# 複製已構建的工件：gems 和應用程式代碼
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# 設置運行時文件的權限
RUN mkdir -p db log storage tmp public/packs && \
    chown -R rails:rails /rails

# 創建非 root 用戶並設置默認運行用戶
RUN useradd -m -s /bin/bash rails
USER rails

# 入口點負責準備資料庫
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# 默認啟動伺服器，這可以在運行時覆蓋
EXPOSE 3000
CMD ["./bin/rails", "server"]
