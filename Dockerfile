# Etapa 1: Build com Node.js 22
FROM node:22-alpine AS build

WORKDIR /app

# Dependências
RUN apk add --no-cache git

# Clone e build do Element Web
RUN git clone https://github.com/vector-im/element-web.git . \
  && yarn install \
  && echo '{}' > config.json \
  && yarn build \
  && cp index.html webapp/index.html

# Etapa 2: Servidor Nginx
FROM nginx:alpine

# Copia arquivos do build
COPY --from=build /app/webapp /usr/share/nginx/html

# Redirecionamento para SPA
RUN echo 'server { listen 80; root /usr/share/nginx/html; index index.html; location / { try_files $uri $uri/ /index.html; } }' > /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
