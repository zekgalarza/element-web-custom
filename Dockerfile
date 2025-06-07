# Etapa 1: build com Node.js 22
FROM node:22-alpine AS build

WORKDIR /app

RUN apk add --no-cache git

# Clona o Element Web oficial e aplica as configurações
RUN git clone https://github.com/vector-im/element-web.git . \
  && yarn install \
  && echo '{ \
    "default_server_config": { \
      "m.homeserver": { \
        "base_url": "https://matrix.zekgalarza.com", \
        "server_name": "matrix.zekgalarza.com" \
      } \
    }, \
    "theme": "custom", \
    "custom_themes": [ \
      { \
        "name": "custom", \
        "ui_theme": "light", \
        "colors": {}, \
        "css_url": "https://element-element-css.1dhseh.easypanel.host/theme-override.css" \
      } \
    ] \
  }' > config.json \
  && yarn build

# Etapa 2: servidor nginx
FROM nginx:alpine

COPY --from=build /app/webapp /usr/share/nginx/html

# Redirecionamento para SPA (Single Page Application)
RUN echo 'server { listen 80; root /usr/share/nginx/html; index index.html; location / { try_files $uri $uri/ /index.html; } }' > /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
