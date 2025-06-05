FROM nginx:alpine

# Copia os arquivos estáticos para o Nginx
COPY . /usr/share/nginx/html

# Cria a configuração nginx corretamente com múltiplas linhas
RUN cat > /etc/nginx/conf.d/default.conf <<EOF
server {
    listen 80;
    server_name localhost;
    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files \$uri \$uri/ /index.html;
    }
}
EOF

CMD ["nginx", "-g", "daemon off;"]
