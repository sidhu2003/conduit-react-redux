# stage 1
FROM node:17-alpine as build
WORKDIR /app
COPY package.json /app
RUN npm install
COPY . /app
RUN npm run build

# stage 2
FROM nginx:1.19.0
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=build /app/build .

