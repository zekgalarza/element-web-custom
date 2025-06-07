# Etapa 1: build do Element Web
FROM node:22-alpine AS build

WORKDIR /app

RUN apk add --no-cache git

RUN git clone https://github.com/vector-im/element-web.git . \
    && yarn install \
    && yarn build

# Copia o CSS customizado após o build
COPY theme-override.css /app/webapp/theme-override.css

# Injeta a tag <link> no index.html
RUN sed -i '/<head>/a <link rel="stylesheet" href="theme-override.css">' /app/webapp/index.html

# Etapa 2: servidor Nginx
FROM nginx:alpine

COPY --from=build /app/webapp /usr/share/nginx/html

RUN echo 'server { \
  listen 80; \
  root /usr/share/nginx/html; \
  index index.html; \
  location / { try_files $uri $uri/ /index.html; } \
}' > /etc/nginx/conf.d/default.conf

