#!/bin/bash
# install-mono-and-build.sh - Автоматическая установка Mono и компиляция

set -e

echo "╔══════════════════════════════════════════════════════════╗"
echo "║  🚀 АВТОМАТИЧЕСКАЯ УСТАНОВКА MONO И КОМПИЛЯЦИЯ HISTORY  ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# Проверяем, установлен ли Mono
if command -v mono &> /dev/null; then
    echo "✅ Mono уже установлен: $(mono --version | head -1)"
    echo ""
else
    echo "⚠️  Mono не найден!"
    echo ""
    echo "Для компиляции .NET Framework 4.5 проекта требуется Mono."
    echo ""
    echo "📥 Варианты установки:"
    echo ""
    echo "   1) Homebrew (если установлен):"
    echo "      brew install mono"
    echo ""
    echo "   2) Официальный инсталлятор:"
    echo "      https://www.mono-project.com/download/stable/#download-mac"
    echo ""
    read -p "Установить Mono через Homebrew сейчас? (y/n): " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if ! command -v brew &> /dev/null; then
            echo "❌ Homebrew не установлен!"
            echo "Установите Homebrew сначала: https://brew.sh/"
            exit 1
        fi
        
        echo "📥 Устанавливаем Mono через Homebrew..."
        brew install mono
    else
        echo ""
        echo "❌ Отменено. Установите Mono вручную и запустите этот скрипт снова."
        exit 1
    fi
fi

# Проверяем msbuild
if ! command -v msbuild &> /dev/null; then
    echo "❌ msbuild не найден после установки Mono!"
    echo "Попробуйте перезапустить терминал или добавить в PATH:"
    echo "export PATH=\"\$PATH:/Library/Frameworks/Mono.framework/Versions/Current/Commands\""
    exit 1
fi

echo ""
echo "🔧 Начинаем компиляцию..."
echo ""

# Переходим в директорию проекта
cd "$(dirname "$0")"

# Компилируем проект
msbuild History.sln /p:Configuration=Release /p:Platform="Any CPU" /verbosity:minimal

# Проверяем результат
if [ -f "History/bin/Release/History.dll" ]; then
    echo ""
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║            ✅ КОМПИЛЯЦИЯ УСПЕШНА!                       ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo ""
    echo "📦 Готовый DLL находится здесь:"
    echo "   $(pwd)/History/bin/Release/History.dll"
    echo ""
    echo "📋 Размер файла: $(du -h History/bin/Release/History.dll | cut -f1)"
    echo ""
    echo "🚀 Следующие шаги:"
    echo "   1. Скопируйте History.dll в папку ServerPlugins/ вашего TShock сервера"
    echo "   2. Выполните SQL миграцию (см. CHANGELOG.md)"
    echo "   3. Перезапустите сервер"
    echo ""
else
    echo ""
    echo "❌ Ошибка! DLL не найден после компиляции."
    echo "Проверьте ошибки компиляции выше."
    exit 1
fi
