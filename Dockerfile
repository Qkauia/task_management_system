# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.2.0
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim

WORKDIR /rails

# 設置環境變數
ENV RAILS_ENV="production" \
    NODE_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    RAILS_SERVE_STATIC_FILES="true" \
    RAILS_LOG_TO_STDOUT="true"

# 更新 gem 和安装 bundler
RUN gem update --system --no-document && \
    gem install bundler -v '2.4.22'

# 安裝系統依賴
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    build-essential \
    libpq-dev \
    libssl-dev \
    zlib1g-dev \
    libyaml-dev \
    libxml2-dev \
    libxslt1-dev \
    libcurl4-openssl-dev \
    software-properties-common \
    libffi-dev \
    curl \
    unzip

RUN apt-get update && apt-get install -y imagemagick

RUN rm -rf /var/lib/apt/lists/*

# 安装 Node.js 和 Yarn
ARG NODE_VERSION=18.17.1
ARG YARN_VERSION=1.22.19
ENV PATH=/usr/local/node/bin:$PATH

RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
    /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
    npm install -g yarn@$YARN_VERSION && \
    rm -rf /tmp/node-build-master

# 安裝 Gems
COPY Gemfile Gemfile.lock ./
RUN bundle config set deployment true && \
    bundle lock --add-platform x86_64-linux && \
    bundle install --jobs=4 --retry=5 --verbose

# 安裝 Node.js 和 Yarn 依賴
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# 複製專案代碼
COPY . .

# 預編譯資產，使用 dummy SECRET_KEY_BASE
RUN SECRET_KEY_BASE=dummy_secret_key_base RAILS_ENV=production bundle exec rails assets:precompile

# 使用非 root 使用者運行應用程式
RUN useradd -m -s /bin/bash rails

# 設置正確的權限
RUN mkdir -p /rails/db /rails/log /rails/storage /rails/tmp && \
    chown -R rails:rails /rails

USER rails:rails

# wait-for-it.sh
COPY wait-for-it.sh /rails/wait-for-it.sh
COPY --chmod=0755 wait-for-it.sh /rails/wait-for-it.sh

EXPOSE 3000

# 使用 entrypoint 啟動應用程式
ENTRYPOINT ["./bin/docker-entrypoint"]

# 最終運行命令
CMD ["bash", "-c", "bundle exec rails s -b '0.0.0.0'"]
