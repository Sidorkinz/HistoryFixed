#!/bin/bash
# build-docker.sh - Скрипт компиляции через Docker

echo "🐳 Сборка History.dll через Docker Mono..."

# Проверяем наличие Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker не установлен! Установите Docker Desktop для macOS:"
    echo "   https://www.docker.com/products/docker-desktop"
    exit 1
fi

# Собираем Docker образ
docker build -t history-builder .

# Запускаем контейнер и компилируем
docker run --rm -v "$(pwd)/output:/build/History/bin" history-builder \
    bash -c "msbuild History.sln /p:Configuration=Release && cp -r History/bin/Release/* /build/History/bin/"

echo ""
echo "✅ Компиляция завершена!"
echo "📦 Готовый DLL находится в: ./output/History.dll"
