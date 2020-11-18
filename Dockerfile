# WARNING: This is not a production-ready setup
# Use this for development only!
FROM ruby:2.7.2-alpine

RUN adduser -D -h /app -s /bin/sh www
WORKDIR /app

RUN apk add --no-cache openssl tini tzdata nodejs yarn libcurl sqlite-libs
RUN gem install bundler

COPY Gemfile* ./
RUN apk add --no-cache --virtual build-deps build-base openssl-dev curl-dev sqlite-dev && \
    bundle install && \
    apk del --purge build-deps && \
    rm -r ~/.bundle/cache && \
    rm -r /usr/local/bundle/cache && \
    chown -R www *

COPY . .
RUN  chown -R -L www *

ENV RAILS_LOG_TO_STDOUT=true

USER www

ENTRYPOINT ["/sbin/tini", "--", "bundle", "exec"]
CMD ["puma", "-C", "/app/config/puma.rb"]
