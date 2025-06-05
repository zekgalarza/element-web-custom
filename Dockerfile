FROM nginx:alpine

COPY . /usr/share/nginx/html

# Força o Nginx a usar index.html mesmo se não for padrão
RUN echo 'index index.html;' > /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
