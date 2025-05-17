# ==================== СТЕЙДЖ 1: Сборка ====================
FROM eclipse-temurin:21-jdk-alpine AS builder

RUN apk add --no-cache maven git \
    && rm -rf /var/cache/apk/*

WORKDIR /build
COPY pom.xml .

RUN mvn dependency:go-offline

COPY src ./src
RUN mvn package -DskipTests

# ==================== СТЕЙДЖ 2: Запуск ====================
FROM eclipse-temurin:21-jre-alpine

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=builder /build/target/*.jar /app/app.jar

ENV APP_PORT=8080
ENV JAVA_OPTS=""

WORKDIR /app
USER appuser

ENTRYPOINT ["sh", "-c", "java ${JAVA_OPTS} -jar app.jar --server.port=${APP_PORT}"]