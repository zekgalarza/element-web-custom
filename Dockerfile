FROM nginx:alpine

# Copia arquivos estáticos para a pasta pública
COPY . /usr/share/nginx/html

# Cria configuração Nginx mínima para servir index.html corretamente
RUN echo 'server {\n\
    listen 80;\n\
    server_name localhost;\n\
    root /usr/share/nginx/html;\n\
    index index.html;\n\
    location / {\n\
        try_files $uri $uri/ /index.html;\n\
    }\n\
}' > /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
