FROM node:16-alpine3.14

WORKDIR /usr/local/remune/devmune-contracts-workbench

RUN apk add --no-cache \
  git \
  && git clone https://github.com/borisovdev/devmune-contracts-workbench.git . --verbose \
  && npm i
