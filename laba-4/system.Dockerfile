FROM eclipse-temurin:21-jdk-alpine

RUN apk add --no-cache \
    maven \
    git \
    && rm -rf /var/cache/apk/*

RUN addgroup -S appgroup && adduser -S appuser -G appgroup