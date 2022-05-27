FROM node:16-alpine3.14 as app_layer

WORKDIR /usr/local/remune/devmune-ui

RUN apk update \
    && apk add --no-cache \
      git \
    && git clone https://github.com/borisovdev/devmune-ui.git --verbose .

COPY .env ./

RUN npm i \
    && npm run build

FROM nginx:1.21.6-alpine as web_layer

WORKDIR /var/www/devmune-ui

COPY --from=app_layer /usr/local/remune/devmune-ui/ /var/www/devmune-ui/

ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD ["nginx", "-g", "daemon off;"]
