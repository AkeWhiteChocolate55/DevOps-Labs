FROM eclipse-temurin:21-jre-alpine

RUN apk add --no-cache postgresql-client bash \
    && rm -rf /var/cache/apk/*

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

RUN mkdir -p /app/migrations

COPY pom.xml /app/
COPY target/laba2-1.0-SNAPSHOT.jar /app/
COPY entrypoint.sh /app/
COPY migrations/ /app/migrations/

RUN chmod +x /app/entrypoint.sh

WORKDIR /app
USER appuser

ENTRYPOINT ["/app/entrypoint.sh"]