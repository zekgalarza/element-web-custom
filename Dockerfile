# Etapa 1: Build com Node.js 22
FROM node:22-alpine as build
WORKDIR /app
RUN apk add --no-cache git

# Clone do Element Web oficial
RUN git clone https://github.com/vector-im/element-web.git . \
  && yarn install \
  && echo '{}' > config.json \
  && yarn build:bundle

# Etapa 2: Servidor Nginx
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html

# Redirecionamento de SPA
RUN echo 'server { listen 80; root /usr/share/nginx/html; index index.html; location / { try_files $uri $uri/ /index.html; } }' > /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]

