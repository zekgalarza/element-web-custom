FROM nginx:alpine

COPY . /usr/share/nginx/html

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

