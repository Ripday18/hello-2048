FROM nginx:1-alpine-slim
EXPOSE 80
COPY ./public_html /usr/share/nginx/html

