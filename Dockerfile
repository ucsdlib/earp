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
  && rm -rf /var/cache/apk/*

RUN addgroup -S highfive && \
    adduser -S highfive -G highfive
USER highfive

WORKDIR /home/highfive/app

ENV RAILS_ENV=development
ENV RACK_ENV=development
ENV RAILS_LOG_TO_STDOUT=true
ENV RAILS_ROOT=/home/highfive/app
ENV LANG=C.UTF-8
ENV GEM_HOME=/home/highfive/bundle
ENV BUNDLE_PATH=$GEM_HOME
ENV BUNDLE_APP_CONFIG=$BUNDLE_PATH
ENV BUNDLE_BIN=$BUNDLE_PATH/bin
ENV PATH=/home/highfive/app/bin:$BUNDLE_BIN:$PATH

COPY --chown=highfive:highfive Gemfile* /home/highfive/app/
RUN gem update bundler \
    && bundle install --jobs "$(nproc)" --retry 2 \
    && rm -rf $BUNDLE_PATH/cache/*gem \
    && find $BUNDLE_PATH/gems/ -name "*.c" -delete \
    && find $BUNDLE_PATH/gems/ -name "*.o" -delete

COPY --chown=highfive:highfive . /home/highfive/app/

CMD ["bundle", "exec", "puma", "-b", "tcp://0.0.0.0:3000"]
ENTRYPOINT ["/bin/sh", "/home/highfive/app/docker/docker-entrypoint.sh"]

FROM ruby:$RUBY_VERSION-alpine as production

RUN apk --no-cache upgrade && \
  apk add --no-cache \
  postgresql-dev \
  nodejs \
  tzdata \
  && rm -rf /var/cache/apk/*

RUN addgroup -S highfive && \
    adduser -S highfive -G highfive
USER highfive

WORKDIR /home/highfive/app

ENV RAILS_ENV=production
ENV RACK_ENV=production
ENV RAILS_LOG_TO_STDOUT=true
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_ROOT=/home/highfive/app
ENV LANG=C.UTF-8
ENV GEM_HOME=/home/highfive/bundle
ENV BUNDLE_PATH=$GEM_HOME
ENV BUNDLE_APP_CONFIG=$BUNDLE_PATH
ENV BUNDLE_BIN=$BUNDLE_PATH/bin
ENV PATH=/home/highfive/app/bin:$BUNDLE_BIN:$PATH
ENV SECRET_KEY_BASE=something

COPY --from=development /home/highfive/bundle /home/highfive/bundle
COPY --from=development /home/highfive/app ./

RUN RAILS_ENV=production bundle exec rake assets:precompile

RUN rm -rf tmp/* log/* spec app/assets vendor/dictionary*

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-b", "tcp://0.0.0.0:3000"]
ENTRYPOINT ["/bin/sh", "/home/highfive/app/docker/docker-entrypoint.sh"]
