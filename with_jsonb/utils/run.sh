#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' #nc no color

set -a
source .env
set +a

echo -e "${YELLOW}=== ЗАПУСК ИНФРАСТРУКТУРЫ ДЛЯ ТЕСТИРОВАНИЯ ИЕРАРХИИ ПАПОК ===${NC}"
SERVICE_NAME="db" 

# проверка наличия docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Ошибка: Docker не установлен${NC}"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}Ошибка: Docker Compose не установлен${NC}"
    exit 1
fi

echo -e "${YELLOW}Остановка существующих контейнеров...${NC}"
docker-compose down -v 2>/dev/null || true

echo -e "${YELLOW}Запуск контейнера...${NC}"
docker-compose up -d

# ожидание готовности базы данных
echo -e "${YELLOW}Ожидание готовности базы данных...${NC}"
max_attempts=60
attempt=0
while [ $attempt -lt $max_attempts ]; do
    if docker-compose exec -T "$SERVICE_NAME" pg_isready -U "$POSTGRES_USER" -d "$POSTGRES_DB" > /dev/null 2>&1; then
        echo -e "${GREEN}База данных готова к работе${NC}"
        break
    fi
    attempt=$((attempt + 1))
    echo -n "."
    sleep 1
done

if [ $attempt -eq $max_attempts ]; then
    echo -e "${RED}Ошибка: База данных не запустилась за отведенное время${NC}"
    docker-compose logs
    exit 1
fi

# проверка создания таблицы
echo -e "${YELLOW}Проверка структуры базы данных...${NC}"
if docker-compose exec -T "$SERVICE_NAME" psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'folder_hierarchy');" | grep -q "t"; then
    echo -e "${GREEN}Таблица folder_hierarchy создана успешно${NC}"
else
    echo -e "${RED}Ошибка: Таблица folder_hierarchy не создана${NC}"
    exit 1
fi

# проверка создания функции
echo -e "${YELLOW}Проверка функции get_parents...${NC}"
if docker-compose exec -T "$SERVICE_NAME" psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "SELECT EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'get_parents');" | grep -q "t"; then
    echo -e "${GREEN}Функция get_parents создана успешно${NC}"
else
    echo -e "${RED}Ошибка: Функция get_parents не создана${NC}"
    exit 1
fi

# запуск теста
echo -e "${YELLOW}Запуск автоматического теста...${NC}"
echo "----------------------------------------"
docker-compose exec -T "$SERVICE_NAME" psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /docker-entrypoint-initdb.d/parents_list.sql
test_exit_code=$?
echo "----------------------------------------"

docker-compose exec -T "$SERVICE_NAME" psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /docker-entrypoint-initdb.d/test.sql

echo ""
echo -e "${YELLOW}=== ИНФРАСТРУКТУРА ГОТОВА ===${NC}"
echo -e "${YELLOW}Для просмотра логов: docker-compose logs -f${NC}"
echo -e "${YELLOW}Для остановки: docker-compose down${NC}"