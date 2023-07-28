FROM node:18.17.0-alpine3.18 as dependencies

WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Stage 1: build environment
FROM node:18.17.0-alpine3.18 as builder

WORKDIR /app
COPY package.json ./
RUN yarn install --frozen-lockfile
COPY . ./
RUN yarn build

FROM node:18.17.0-alpine3.18

RUN apk --update --no-cache add busybox-extras && apk add curl && apk add nginx
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf

WORKDIR /app
COPY --from=builder /app/public ./public
COPY --from=builder /app/yarn.lock /app/package.json ./
COPY --from=dependencies /app/node_modules ./node_modules


EXPOSE 9000
CMD [ "yarn", "serve" ]
