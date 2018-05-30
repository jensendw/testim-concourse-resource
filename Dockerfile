FROM node:6.14.2-alpine

RUN apk add --no-cache curl bash jq gettext-dev

RUN npm i -g @testim/testim-cli

COPY check /opt/resource/check
COPY in    /opt/resource/in
COPY out   /opt/resource/out

ADD test/ /opt/resource-tests/

RUN chmod +x /opt/resource/out /opt/resource/in /opt/resource/check

RUN /opt/resource-tests/all.sh \
 && rm -rf /tmp/*
