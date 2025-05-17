# **Лабораторная работа: Запуск Nginx в Docker**

## **Цель**
Настроить и запустить веб-сервер Nginx внутри контейнера Docker, используя легковесный образ Alpine Linux. 

## **Задачи**
1. Создать Docker-образ `mynginx`, который запускает Nginx внутри контейнера.
2. Получить ответ от Nginx по адресу `http://localhost:8080`.
3. Использовать базовый образ `alpine`.
4. Позволить конфигурировать Nginx через внешний файл `nginx.conf`.
5. Подключить статические файлы через внешний `volume`.
6. Запускать контейнер от **непривилегированного** пользователя.
7. Написать `docker-compose.yml` для удобного управления контейнером.

---

## **1. Структура проекта**
```
.
├── Dockerfile
├── docker-compose.yml
├── nginx.conf
├── html/
│   ├── index.html
└── README.md
```

---

## **2. Создание `Dockerfile`**
Файл `Dockerfile` содержит инструкции для сборки образа:

```dockerfile
# Используем легковесный образ Alpine
FROM alpine:latest

# Устанавливаем nginx
RUN apk add --no-cache nginx 

# Копируем кастомный конфиг
COPY nginx.conf /etc/nginx/nginx.conf

# Создаем пользователя и директории
RUN adduser -D -g 'www' www \
    && mkdir -p /var/www/html /var/lib/nginx/tmp /var/lib/nginx/logs /var/run/nginx \
    && chown -R www:www /var/www/html /var/lib/nginx /var/run/nginx \
    && chmod -R 755 /var/lib/nginx /var/run/nginx

# Указываем пользователя для контейнера
USER www

# Открываем порт
EXPOSE 80

# Запускаем nginx
CMD ["nginx", "-g", "daemon off;"]
```

---

## **3. Конфигурационный файл `nginx.conf`**

```nginx
worker_processes  1;
error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx/nginx.pid;

events {
    worker_connections  1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;
    
    server {
        listen       80;
        server_name  localhost;
        root   /var/www/html;
        index  index.html;

        location / {
            try_files $uri $uri/ =404;
        }
    }
}
```

---

## **4. Файл `docker-compose.yml`**

```yaml
version: '3.8'
services:
  nginx:
    build: .
    container_name: mynginx
    ports:
      - "8080:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - ./html:/var/www/html:ro
      - ./nginx-logs:/var/lib/nginx/logs
      - ./nginx-tmp:/var/lib/nginx/tmp
    restart: unless-stopped
```

---

## **5. Создание статической страницы**
Создадим `html/index.html`:

```html
<!DOCTYPE html>
<html>
<head>
    <title>My Nginx in Docker</title>
</head>
<body>
    <h1>Hello from Nginx in Docker!</h1>
</body>
</html>
```

---

## **6. Запуск контейнера**

### **Шаг 1: Собираем и запускаем контейнер**
```sh
docker-compose up --build -d
```

### **Шаг 2: Проверяем работу Nginx**
Перейди в браузере по адресу:
```
http://localhost:8080
```
Если всё сделано правильно, отобразится страница с текстом `Hello from Nginx in Docker!`

---

## **7. Остановка контейнера**

Чтобы остановить и удалить контейнер, используй:
```sh
docker-compose down
```