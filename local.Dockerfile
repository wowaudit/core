# To run locally on M1 Mac:
# docker build . --platform linux/arm64/v8 -t shedi/wowaudit-arm

FROM ruby:3.1.3-slim

RUN apt-get update

RUN \
  apt-get install -y \
  tzdata \
  gcc \
  g++ \
  make \
  curl \
  libjemalloc2 \
  libmariadb-dev \
  git

RUN rm -rf /var/lib/apt/lists/*

WORKDIR /srv

COPY bin /srv/bin
COPY lib /srv/lib
COPY config /srv/config
COPY config/external_database.yml /srv/config/database.yml
COPY Gemfile Gemfile.lock /srv/

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin

RUN \
  bundle install --frozen --verbose --no-cache --deployment --binstubs bin --without test development \
  && bundle

ENV LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libjemalloc.so.2

CMD ["bundle", "exec", "ruby", "/srv/bin/refresh_ids.rb", "43443", "essentials"]
