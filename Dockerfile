# syntax = docker/dockerfile:1

# 基础构建阶段
ARG RUBY_VERSION=3.2.0
FROM ruby:$RUBY_VERSION-slim AS base

# Node.js 构建阶段
FROM node:16-alpine AS nodebuild

WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install

# Rails 构建阶段
FROM base AS build

WORKDIR /rails

# 安装系统依赖
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential git libpq-dev libvips pkg-config

# 复制 Node.js 构建结果
COPY --from=nodebuild /app/node_modules ./node_modules

# 安装 Ruby 依赖
COPY Gemfile Gemfile.lock ./
RUN bundle install

# 复制应用代码
COPY . .

# 继续处理 Rails 和其他操作
# ...
