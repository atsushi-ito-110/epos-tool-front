FROM node:14.15.0-alpine

ENV LANG=C.UTF-8 TZ=Asia/Tokyo

WORKDIR /app

RUN apk update

COPY ./package*.json ./

RUN npm install && npm install -g gulp

COPY ./ .

ENV HOST 0.0.0.0
EXPOSE 3000
