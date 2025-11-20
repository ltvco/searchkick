# Builder stage
FROM ruby:3.4.4-slim-bookworm AS builder

ARG BUNDLE_GEMSTASH__LTVOPS__COM

RUN apt-get update \
    && (rm /var/lib/man-db/auto-update 2>/dev/null || true) \
    && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    curl \
    libsqlite3-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN cp /usr/share/zoneinfo/US/Central /etc/localtime && echo "US/Central" > /etc/timezone

WORKDIR /app

COPY Gemfile* searchkick.gemspec ./
COPY lib/searchkick/version.rb ./lib/searchkick/

RUN gem install bundler \
    && bundle install --jobs 4 --retry 3

EXPOSE 3000

CMD ["bundle", "exec", "rake", "test"]
