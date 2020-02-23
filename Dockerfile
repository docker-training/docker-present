FROM training/docker-present:ee2.1-v1.8


# setup
COPY present/present.py /opt/revealjs/
COPY present/css/docker.css /opt/revealjs/css/theme/
COPY present/css/docker-code.css /opt/revealjs/lib/css/
COPY present/css/sd_custom.css /opt/revealjs/css/
COPY present/css/print /opt/revealjs/css/print/
COPY present/fonts /opt/revealjs/fonts/
COPY present/images /opt/revealjs/images/
COPY present/templates /opt/revealjs/templates
COPY present/prompt.sh /bin/prompt
COPY present/reveal.js /opt/revealjs/js/reveal.js

# default presentation repository
RUN rm -rf /opt/revealjs/src
ADD presentations /opt/revealjs/src

ENTRYPOINT ["/bin/prompt"]
