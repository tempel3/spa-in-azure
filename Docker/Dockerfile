# https://medium.com/@vishal.sharma./dockerizing-angular-app-using-docker-multi-stage-build-d9151441f2c4


# Stage 1
FROM node:14 as build
WORKDIR /app
COPY App/package*.json /app/

RUN npm install
COPY App/. /app

ARG configuration=production
RUN npm run build -- --outputPath=./dist/out --configuration $configuration

# Stage 2
FROM nginx:1.19-alpine
COPY --from=build /app/dist/out/ /usr/share/nginx/html
COPY nginx-custom.conf /etc/nginx/conf.d/default.conf