

# Etapa 1: Build
FROM node:22-alpine AS build

WORKDIR /app

RUN apk add --no-cache git \
 && git clone https://github.com/vector-im/element-web.git . \
 && yarn install

# Copia SCSS customizado
COPY theme-override.scss /app/theme-override.scss

# Injeta @import no início do index.scss
RUN echo '@import "../../theme-override.scss";' | cat - src/vector/index.scss > temp && mv temp src/vector/index.scss \
 && yarn build

# Etapa 2: Nginx
FROM nginx:alpine

COPY --from=build /app/webapp /usr/share/nginx/html
COPY index.html /usr/share/nginx/html/index.html
COPY config.json /usr/share/nginx/html/config.json

RUN echo 'server {\n\
  listen 80;\n\
  root /usr/share/nginx/html;\n\
  index index.html;\n\
  location / { try_files $uri $uri/ /index.html; }\n\
}' > /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]

