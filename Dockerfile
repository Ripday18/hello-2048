FROM nginx:1.23-alpine-slim
COPY ./public_html/ /usr/share/nginx/html
EXPOSE 80
LABEL org.opencontainers.image.source https://github.com/qebyn/hello-2048

