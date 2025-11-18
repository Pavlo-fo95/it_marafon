# -------- build --------
FROM node:22.16.0 AS build

# Vite-переменные на этапе сборки
ARG VITE_ENV=production
ARG VITE_API_URL=/api       # через ALB, /api уйдёт в backend

ENV VITE_ENV=$VITE_ENV
ENV VITE_API_URL=$VITE_API_URL

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# -------- runtime --------
FROM alpine:3.21

RUN apk update && apk add --no-cache nginx bash curl netcat-openbsd

# Статические файлы фронта
COPY --from=build /app/dist /usr/share/nginx/html

# Конфиг Nginx (важно, чтобы там был proxy_pass для /api -> backend)
COPY nginx.conf /etc/nginx/http.d/default.conf

HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
  CMD curl -f http://localhost:80/ || exit 1

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
