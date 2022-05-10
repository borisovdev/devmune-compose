FROM node:16-alpine3.14

WORKDIR /usr/local/devmune/node-controller

RUN apk update \
    && apk add --no-cache \
      git \
    && git clone https://github.com/borisovdev/devmune-node-controller.git . --verbose \
    && npm i

CMD npm run dev
