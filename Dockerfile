# Etapa 1: Build do Element Web
FROM node:22-alpine AS build

WORKDIR /app

# Dependências
RUN apk add --no-cache git

# Clone do Element Web e substitui o index.html personalizado
RUN git clone https://github.com/vector-im/element-web.git . \
  && yarn install \
  && cp index.html src/index.html \
  && yarn build

# Etapa 2: Servidor Nginx
FROM nginx:alpine

# Copia o build final para o Nginx
COPY --from=build /app/webapp /usr/share/nginx/html

# Redirecionamento para SPA
RUN echo 'server {\n  listen 80;\n  root /usr/share/nginx/html;\n  index index.html;\n  location / { try_files $uri $uri/ /index.html; }\n}' > /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]

