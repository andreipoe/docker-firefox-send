FROM node:8-alpine
MAINTAINER Andrei Poenaru <donot@keemail.me>

# The Send version to build (git treeish)
ARG version=v2.5.4

RUN apk add --no-cache git
RUN addgroup -S -g 10001 app && adduser -S -D -G app -u 10001 app

# Download the Send code
RUN git clone https://github.com/mozilla/send.git /app -b $version --depth=1
WORKDIR /app

# First step of the build (which Mozilla do on the host)
RUN npm i get-firefox geckodriver nsp
RUN npm install
RUN npm run build

# Remove files not needed for running
COPY dockerignore /app/.dockerignore
RUN for i in $(cat .dockerignore); do rm -rf "$i"; done

# Second step of the build (same as in the Mozilla Dockerfile)
RUN chown -R app /app
USER app
RUN mkdir static && rm -rf node_modules
RUN npm install --production && npm cache clean --force

ENV PORT=1443
EXPOSE $PORT

CMD ["npm", "run", "prod"]

