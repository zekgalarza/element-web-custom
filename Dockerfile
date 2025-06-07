# Etapa 1: build do Element Web
FROM node:22-alpine AS build

WORKDIR /app

# Instala dependências e clona o projeto
RUN apk add --no-cache git \
  && git clone https://github.com/vector-im/element-web.git . \
  && yarn install \
  && yarn build

# Etapa 2: servidor Nginx para servir os arquivos estáticos
FROM nginx:alpine

# Copia os arquivos do build para o diretório do Nginx
COPY --from=build /app/webapp /usr/share/nginx/html

# Copia o CSS customizado
COPY theme-override.css /usr/share/nginx/html/theme-override.css

# Injeta o CSS customizado no <head> do index.html
RUN sed -i '/<\/head>/i <link rel="stylesheet" href="theme-override.css">' /usr/share/nginx/html/index.html

# Redirecionamento padrão do Nginx para SPA
RUN echo 'server {\n\
  listen 80;\n\
  root /usr/share/nginx/html;\n\
  index index.html;\n\
  location / { try_files $uri $uri/ /index.html; }\n\
}' > /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]




