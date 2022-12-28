FROM nginx:latest

ENV API_URL api.gehege.ch

COPY ./build/web /usr/share/nginx/html

WORKDIR /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]