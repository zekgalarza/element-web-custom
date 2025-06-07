# Etapa 1: build com Node 22
FROM node:22-alpine as build

WORKDIR /app

# Instala git e clona o Element
RUN apk add --no-cache git

RUN git clone https://github.com/vector-im/element-web.git . \
  && yarn install \
  && echo '{}' > config.json \
  && yarn build

# Etapa 2: imagem leve com Nginx
FROM nginx:alpine

COPY --from=build /app/dist /usr/share/nginx/html

# Nginx para SPAs: redireciona rotas internas para /index.html
RUN echo 'server { listen 80; root /usr/share/nginx/html; index index.html; location / { try_files $uri $uri/ /index.html; } }' > /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
