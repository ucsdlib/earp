FROM ruby:2.6.2-alpine

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
COPY --chown=theodor:theodor Gemfile* /home/theodor/app/
RUN gem update bundler
RUN bundle check || bundle install --jobs "$(nproc)" --retry 2
COPY --chown=theodor:theodor . /home/theodor/app/

ENV RAILS_ENV production
RUN bundle exec rake assets:precompile

ENTRYPOINT "bundle exec puma"
