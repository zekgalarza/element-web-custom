# Etapa 1: Build com Node.js 22
FROM node:22-alpine AS build

WORKDIR /app

RUN apk add --no-cache git

# Clona o Element Web
RUN git clone https://github.com/vector-im/element-web.git .

# Substitui o index.html ANTES do build
COPY index.html ./src/vector/index.html

RUN yarn install \
  && echo '{}' > config.json \
  && yarn build

# Etapa 2: Servidor Nginx
FROM nginx:alpine

COPY --from=build /app/webapp /usr/share/nginx/html

RUN echo 'server { listen 80; root /usr/share/nginx/html; index index.html; location / { try_files $uri $uri/ /index.html; } }' > /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
