FROM nginx:1-alpine-slim
COPY ./public_html /usr/share/nginx/html/
EXPOSE 8080
LABEL org.opencontainers.image.source https://github.com/Ripday18/hello-2048

