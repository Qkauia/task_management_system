# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.2.0
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test" \
    RAILS_SERVE_STATIC_FILES="true" \
    RAILS_LOG_TO_STDOUT="true"

RUN gem update --system --no-document && \
    gem install bundler -v '2.4.22'

# 添加 ping 工具的安裝
RUN apt-get update && \
    apt-get install --no-install-recommends -y iputils-ping

FROM base AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    git \
    libpq-dev \
    libvips \
    node-gyp \
    pkg-config \
    python-is-python3 \
    postgresql-client-13

ARG NODE_VERSION=18.17.1
ARG YARN_VERSION=1.22.19
ENV PATH=/usr/local/node/bin:$PATH

RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
    /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
    npm install -g yarn@$YARN_VERSION && \
    rm -rf /tmp/node-build-master

COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs=4 --retry=5 --verbose || { echo "Bundle install failed"; exit 1; }

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY . .

# 編譯前端資產
RUN yarn run build

# 預編譯 Rails 資產
RUN SECRET_KEY_BASE=dummy_secret_key_base ./bin/rails assets:precompile

# 使用 build 階段作為最終階段
FROM build

RUN useradd -m -s /bin/bash rails

RUN apt-get update && \
    apt-get install --no-install-recommends -y libpq-dev curl libvips && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

RUN mkdir -p /rails/db /rails/log /rails/storage /rails/tmp && \
    chown -R rails:rails /rails

USER rails:rails

COPY wait-for-it.sh /rails/wait-for-it.sh
COPY --chmod=+x wait-for-it.sh /rails/wait-for-it.sh

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000

CMD ["bash", "-c", "yarn esbuild app/javascript/application.js --bundle --sourcemap --outdir=app/assets/builds --watch & bundle exec rails s -b '0.0.0.0'"]
