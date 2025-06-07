# Etapa 1: build do Element Web
FROM node:22-alpine AS build

WORKDIR /app

RUN apk add --no-cache git \
  && git clone https://github.com/vector-im/element-web.git . \
  && yarn install

# Copia o config.json customizado
COPY config.json ./webapp/config.json

RUN yarn build

# Etapa 2: servidor Nginx
FROM nginx:alpine

COPY --from=build /app/webapp /usr/share/nginx/html

RUN echo 'server { \
  listen 80; \
  root /usr/share/nginx/html; \
  index index.html; \
  location / { try_files $uri $uri/ /index.html; } \
}' > /etc/nginx/conf.d/default.conf

