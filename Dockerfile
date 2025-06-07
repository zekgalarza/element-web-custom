# Etapa 1: build com yarn
FROM node:20-alpine as build

WORKDIR /app

# Clona o Element oficial
RUN apk add --no-cache git && \
    git clone https://github.com/vector-im/element-web.git . && \
    yarn install && \
    echo '{}' > config.json && \
    yarn build

# Etapa 2: servidor nginx
FROM nginx:alpine

COPY --from=build /app/dist /usr/share/nginx/html

# Rota fallback SPA
RUN echo 'server { listen 80; root /usr/share/nginx/html; index index.html; location / { try_files $uri $uri/ /index.html; } }' > /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
