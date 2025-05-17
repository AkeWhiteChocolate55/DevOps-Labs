FROM eclipse-temurin:21-jre-alpine

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=builder /app/app.jar /app/app.jar

ENV JAVA_OPTS=""
ENV APP_PORT=8080

RUN chown -R appuser:appgroup /app

WORKDIR /app
USER appuser

ENTRYPOINT ["sh", "-c", "java ${JAVA_OPTS} -jar app.jar --server.port=${APP_PORT}"]