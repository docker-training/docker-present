FROM python:2.7

MAINTAINER Jerry Baker <jbaker@docker.com>

# default presentation repository
# Note: Will switch to 'ARG' as soon as Docker Hub and the build stack supports '--build-args'
ENV REPO=https://github.com/docker-training/presentations

RUN apt-get update && apt-get -y install \
    git \
    nodejs \
    tree \
    npm

# docker
RUN curl -sSL https://get.docker.com | sh

# reveal.js
WORKDIR /opt/revealjs
RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN git clone https://github.com/hakimel/reveal.js.git /opt/revealjs
RUN git clone https://github.com/denehyg/reveal.js-menu.git /opt/revealjs/plugin/menu
RUN npm install

# setup
COPY present.py /opt/revealjs/
COPY present/css/docker.css /opt/revealjs/css/theme/
COPY present/css/docker-code.css /opt/revealjs/lib/css/
COPY present/templates /opt/revealjs/templates
COPY prompt.sh /bin/prompt
RUN git clone ${REPO} /opt/revealjs/src

ENTRYPOINT ["/bin/prompt"]
