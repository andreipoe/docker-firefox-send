FROM node:8-alpine
MAINTAINER Andrei Poenaru <donot@keemail.me>

# The Send version to build (git treeish)
ARG version=v1.1.2

RUN apk add --no-cache git
RUN addgroup -S -g 10001 app && adduser -S -D -G app -u 10001 app

# Download the Send code
RUN git clone https://github.com/mozilla/send.git /app -b $version --depth=1
WORKDIR /app

# Remove files not needed for build
COPY dockerignore /app/.dockerignore
RUN for i in $(cat .dockerignore); do rm -rf "$i"; done

# First step of the build (which Mozilla do on the host)
RUN npm i get-firefox geckodriver nsp
RUN npm run build

# Second step of the build (same as in the Mozilla Dockerfile)
RUN chown -R app /app
USER app
RUN mkdir static && rm -rf node_modules
RUN npm install --production && npm cache clean --force

ENV PORT=1443
EXPOSE $PORT

CMD ["npm", "start"]

