FROM voormedia/ruby:3.9

RUN \
  apk add --no-cache \
  tzdata \
  git \
  ruby-dev \
  zlib-dev \
  gcc \
  g++ \
  make \
  musl-dev \
  pkgconfig \
  libxml2-dev \
  libxslt-dev \
  libffi-dev \
  mysql-dev

COPY . /srv/

RUN \
  bundle install --frozen --no-cache --deployment --binstubs bin --without test development \
  && bundle

CMD ["/srv/bin/refresh"]
