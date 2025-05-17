# Лабораторная работа: Docker + Мультистейджинг

## Цель
Создать легковесный Docker-образ Java-приложения с использованием мультистейджинга и PostgreSQL.

## Требования и их обоснование

### 1. Мультистейджинг (`Dockerfile`)
```dockerfile
FROM eclipse-temurin:21-jdk-alpine AS builder
 ...
FROM eclipse-temurin:21-jre-alpine
```

2. Alpine-образы
```dockerfile
FROM ...-alpine
```

3. Очистка кеша
```dockerfile
RUN apk add --no-cache ... && rm -rf /var/cache/apk/*
```

4. Непривилегированный пользователь
```dockerfile
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser
```

5. Миграции БД (entrypoint.sh)
```dockerfile
PGPASSWORD=$DB_PASSWORD psql -h db -U postgres -d mydb -f migration.sql
```

6. Тома данных (docker-compose.yml)
```dockerfile
volumes:
  - pg_data:/var/lib/postgresql/data
```

## Запуск
1. Собрать образ:
```
docker-compose build
```
2. Запустить:
```
docker-compose up -d
```
3. Проверить:
```
curl http://localhost:8080
```