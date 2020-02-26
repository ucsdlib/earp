ARG RUBY_VERSION=2.6.5

FROM ruby:$RUBY_VERSION-alpine as development

RUN apk --no-cache upgrade && \
  apk add --no-cache \
  build-base \
  less \
  postgresql-dev \
  nodejs \
  nodejs-npm \
  tzdata \
  vim \
  && rm -rf /var/cache/apk/*

WORKDIR /app

ENV EDITOR=vim
ENV RAILS_ENV=development
ENV RACK_ENV=development
ENV RAILS_LOG_TO_STDOUT=true
ENV RAILS_ROOT=/app
ENV LANG=C.UTF-8

COPY Gemfile* /app/

RUN gem update bundler && bundle install --jobs "$(nproc)" --retry 2

COPY . /app

CMD ["bundle", "exec", "puma", "-b", "tcp://0.0.0.0:3000"]
ENTRYPOINT ["/bin/sh", "/app/docker/docker-entrypoint.sh"]

FROM ruby:$RUBY_VERSION-alpine as production

RUN apk --no-cache upgrade && \
  apk add --no-cache \
  postgresql-dev \
  nodejs \
  tzdata \
  && rm -rf /var/cache/apk/*

WORKDIR /app

ENV RAILS_ENV=production
ENV RACK_ENV=production
ENV RAILS_LOG_TO_STDOUT=true
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_ROOT=/app
ENV LANG=C.UTF-8
ENV SECRET_KEY_BASE=something
ENV APPS_H5_DELIVERY_METHOD=letter_opener
ENV APPS_H5_APP_HOST=localhost:3000

COPY --from=development /usr/local/bundle /usr/local/bundle
COPY --from=development /app ./

RUN RAILS_ENV=production bundle exec rake assets:precompile

RUN rm -rf tmp/* log/* spec app/assets vendor/dictionary*

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-b", "tcp://0.0.0.0:3000"]
ENTRYPOINT ["/bin/sh", "/app/docker/docker-entrypoint.sh"]
