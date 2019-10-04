#Base Image
FROM ruby:2.6.3-alpine AS base

RUN apk --no-cache upgrade && \
  apk add --no-cache \
  build-base \
  postgresql-dev \
  nodejs \
  nodejs-npm \
  tzdata

#Add non-root user
RUN addgroup -g 1000 -S theodor && \
    adduser -u 1000 -S theodor -G theodor
USER theodor

#Set WORKDIR
WORKDIR /home/theodor/app

#Copy Gemfile locks
COPY --chown=theodor:theodor Gemfile* ./
RUN gem update bundler
RUN bundle check || bundle install --jobs "$(nproc)" --retry 2
COPY --chown=theodor:theodor . ./

#Development image
FROM base AS development

#Development entrypoint
ENTRYPOINT ["/bin/sh", "/home/theodor/app/docker/docker-entrypoint.sh"]

#Production image
FROM base AS production

ENV RAILS_ENV production
RUN bundle exec rake assets:precompile

ENTRYPOINT "bundle exec puma"
