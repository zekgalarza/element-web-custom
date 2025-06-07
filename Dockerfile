# Etapa 1: build do Element Web
FROM node:22-alpine AS build

WORKDIR /app

# Instala dependências e clona o projeto
RUN apk add --no-cache git \
  && git clone https://github.com/vector-im/element-web.git . \
  && yarn install \
  && yarn build

# Etapa 2: Nginx para servir os arquivos
FROM nginx:alpine

# Copia o resultado do build
COPY --from=build /app/webapp /usr/share/nginx/html

# ✅ Copia o config.json final após o build (visível via /config.json)
COPY config.json /usr/share/nginx/html/config.json

# Configuração padrão para SPA
RUN echo 'server { \
  listen 80; \
  root /usr/share/nginx/html; \
  index index.html; \
  location / { try_files $uri $uri/ /index.html; } \
}' > /etc/nginx/conf.d/default.conf
