# Stage 1: build environment
FROM node:18.17.0-alpine3.18
COPY . ./
RUN yarn
RUN yarn build

## run server
CMD ["npm", "run", "serve"]
