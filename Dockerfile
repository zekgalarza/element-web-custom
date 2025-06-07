# Etapa 1: build do Element Web
FROM node:22-alpine AS build

WORKDIR /app

# Instala dependências e clona o projeto
RUN apk add --no-cache git \
  && git clone https://github.com/vector-im/element-web.git . \
  && yarn install

# Copia o config.json personalizado antes do build
COPY config.json ./webapp/config.json

# Faz o build
RUN yarn build

# Etapa 2: servidor Nginx para servir os arquivos estáticos
FROM nginx:alpine

# Copia os arquivos do build para o diretório do Nginx
COPY --from=build /app/webapp /usr/share/nginx/html

# Configuração padrão do Nginx para SPA (Single Page Application)
RUN echo 'server { \
  listen 80; \
  root /usr/share/nginx/html; \
  index index.html; \
  location / { try_files $uri $uri/ /index.html; } \
}' > /etc/nginx/conf.d/default.conf
