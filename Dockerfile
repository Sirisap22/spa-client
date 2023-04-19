FROM node:18-alpine as base

WORKDIR /app
COPY . .
RUN npm ci
RUN npm run build

FROM nginx:1.19-alpine as production

WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=base /app/dist .
ENTRYPOINT ["nginx", "-g", "daemon off;"]

