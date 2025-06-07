# Etapa 1: build do Element Web
FROM node:22-alpine AS build

WORKDIR /app

RUN apk add --no-cache git \
  && git clone https://github.com/vector-im/element-web.git . \
  && yarn install \
  && yarn build

# Etapa 2: servidor Nginx para servir os arquivos estáticos
FROM nginx:alpine

# Copia o resultado do build
COPY --from=build /app/webapp /usr/share/nginx/html

# Copia o CSS customizado
COPY theme-override.css /usr/share/nginx/html/theme-override.css

# Substitui o index.html modificado que injeta o CSS
COPY index.html /usr/share/nginx/html/index.html

# Configuração padrão do Nginx para SPA
RUN echo 'server { \
  listen 80; \
  root /usr/share/nginx/html; \
  index index.html; \
  location / { try_files $uri $uri/ /index.html; } \
}' > /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]

