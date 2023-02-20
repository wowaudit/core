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

COPY Gemfile Gemfile.lock /srv/

RUN \
  bundle install --frozen --verbose --no-cache --deployment --binstubs bin --without test development \
  && bundle

COPY bin /srv/bin
COPY lib /srv/lib
COPY config /srv/config

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin

ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2

CMD ["/srv/bin/refresh"]
