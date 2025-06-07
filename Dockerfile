# Etapa 1: build do Element Web
FROM node:22-alpine AS build

WORKDIR /app

# Instala dependências e clona o projeto
RUN apk add --no-cache git \
  && git clone https://github.com/vector-im/element-web.git . \
  && yarn install

# Copia o SCSS customizado para a pasta src
COPY theme-override.scss src/theme-override.scss

# Importa o SCSS no index.scss antes do build
RUN echo '\n@import "../theme-override.scss";' >> src/vector/index.scss \
  && yarn build

# Etapa 2: servidor Nginx para servir os arquivos estáticos
FROM nginx:alpine

# Copia os arquivos do build para o diretório do Nginx
COPY --from=build /app/webapp /usr/share/nginx/html

# Copia arquivos customizados (opcional)
COPY index.html /usr/share/nginx/html/index.html
COPY config.json /usr/share/nginx/html/config.json

# Redirecionamento padrão do Nginx para SPA
RUN echo 'server {\n\
  listen 80;\n\
  root /usr/share/nginx/html;\n\
  index index.html;\n\
  location / { try_files $uri $uri/ /index.html; }\n\
}' > /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]



