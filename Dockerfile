# Etapa 1: build do Element Web
FROM node:22-alpine AS build

WORKDIR /app

# Instala dependências e clona o Element Web
RUN apk add --no-cache git \
  && git clone https://github.com/vector-im/element-web.git . \
  && yarn install

# Copia o SCSS customizado para o lugar correto
COPY theme-override.scss src/vector/theme-override.scss

# Injeta o import no início de styles.scss
RUN sed -i '1s|^|@import "theme-override.scss";\n|' src/vector/styles.scss \
  && yarn build

# Etapa 2: nginx para servir os arquivos
FROM nginx:alpine

COPY --from=build /app/webapp /usr/share/nginx/html
COPY config.json /usr/share/nginx/html/config.json
COPY index.html /usr/share/nginx/html/index.html

# Configuração de redirecionamento SPA
RUN echo 'server {\n\
  listen 80;\n\
  root /usr/share/nginx/html;\n\
  index index.html;\n\
  location / { try_files $uri $uri/ /index.html; }\n\
}' > /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
