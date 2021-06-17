FROM node:16

RUN curl -sSL https://get.docker.com | sh 

COPY reveal.js-4.1.2 /opt/revealjs
COPY images /opt/revealjs/images/
COPY templates /opt/revealjs/templates
COPY prompt.sh /bin/prompt
COPY present.py /opt/revealjs/
ADD presentations /opt/revealjs/src

WORKDIR /opt/revealjs

ENTRYPOINT ["/bin/prompt"]
