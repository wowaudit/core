FROM ghcr.io/graalvm/truffleruby:22.3.1

WORKDIR /srv

COPY bin /srv/bin
COPY lib /srv/lib
COPY config /srv/config
COPY Gemfile Gemfile.lock /srv/

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin

RUN \
  bundle install --frozen --no-cache --deployment --binstubs bin --without test development \
  && bundle

CMD ["/srv/bin/refresh"]
