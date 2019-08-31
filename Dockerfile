
# STAGE 1: Build

FROM node:12-alpine as builder

COPY package.json package-lock.json ./

RUN npm ci && mkdir /app && mv ./node_modules ./app

WORKDIR /app

COPY . .

RUN npm run ng build -- --prod --output-path=dist

# STAGE 2: Deploy

FROM nginx:1.17-alpine

COPY nginx/default.conf.template /etc/nginx/conf.d/

RUN rm -rf /usr/share/nginx/html/*

COPY --from=builder /app/dist /usr/share/nginx/html

COPY run.sh /

CMD ["/run.sh"]
