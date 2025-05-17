# Лабораторная работа: Docker Multi-stage Build

**Цель**: Создание безопасного и оптимизированного Java-приложения в Docker с разделением зависимостей.

## Структура образов

1. **system** (базовые зависимости):
    - JDK 21 + Maven
    - Создан пользователь `appuser`

2. **builder** (сборка):
    - Только сборка JAR (без установки зависимостей)
    - Использует образ `system`

3. **runtime** (запуск):
    - Только JRE 21
    - Запуск от `appuser`

## Как проверить

1. Собрать образы:
```bash
docker build -t system -f system.Dockerfile .
docker build -t builder -f build.Dockerfile .
docker build -t my-app -f runtime.Dockerfile .
```
2. Запустить:
```bash
docker-compose up -d 
```