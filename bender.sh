#!/bin/bash

WG_CONTAINER=$(docker ps -a --format '{{.Names}}' | grep -iE 'wg|wireguard' | head -n 1)

if [ -z "$WG_CONTAINER" ]; then
    echo "❌ Ошибка: Контейнер WG-Easy не найден!"
    echo "Проверьте запущенные контейнеры: docker ps -a"
    exit 1
fi

echo "Найден контейнер WG-Easy: $WG_CONTAINER"

read -p "bender (docker cp app.js ${WG_CONTAINER}:/app/www/img/logo.png)? (y/n) " choice

if [[ "$choice" =~ [yY] ]]; then
    echo "Загружаю файлы..."
    curl -sSL https://raw.githubusercontent.com/nolaxe/wg_to_easy/main/bender.png -o logo.png
    echo "Копирую в контейнер ${WG_CONTAINER}..."
    docker cp logo.png ${WG_CONTAINER}:/app/www/img/logo.png && echo "logo.png скопирован успешно"
    # rm -f logo.png
    echo "✅ Готово! Контейнер ${WG_CONTAINER} обновлен."
else
    echo "ℹ️ Отмена."
    exit 0
fi
