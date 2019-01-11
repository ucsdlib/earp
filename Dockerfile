FROM ruby:2.6.0-alpine as builder

RUN apk --no-cache upgrade && \
  apk add --no-cache \
  build-base \
  postgresql \
  postgresql-dev \
  nodejs \
  nodejs-npm \
  tzdata

RUN mkdir -p /build-src
WORKDIR /build-src
COPY Gemfile* ./
RUN bundle install --jobs 4 --retry 2

FROM ruby:2.6.0-alpine

RUN apk --no-cache upgrade && \
  apk add --no-cache \
  postgresql-dev \
  nodejs \
  nodejs-npm \
  tzdata

RUN addgroup -g 1000 -S theodor && \
    adduser -u 1000 -S theodor -G theodor
USER theodor

RUN mkdir -p /home/theodor/app
WORKDIR /home/theodor/app
COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --chown=theodor:theodor . /home/theodor/app/

ENV RAILS_ENV production
RUN bundle exec rake assets:precompile

ENTRYPOINT "bundle exec puma"
