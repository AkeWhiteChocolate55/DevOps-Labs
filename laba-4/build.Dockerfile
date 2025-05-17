FROM system as builder

WORKDIR /build

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn package -DskipTests \
    && mkdir -p /app \
    && cp target/*.jar /app/app.jar