#!/bin/bash

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "=================================================="
echo "  🐳 INICIANDO AMBIENTE LOCAL (MongoDB Docker)"
echo "=================================================="
echo ""

# Parar ambiente Atlas se estiver rodando
if docker ps -a | grep -q "jwt-auth-app-atlas"; then
    echo -e "${YELLOW}⏸️  Parando ambiente Atlas...${NC}"
    docker-compose -f docker-compose.atlas.yml down
    echo ""
fi

echo -e "${BLUE}🚀 Iniciando ambiente LOCAL...${NC}"
docker-compose -f docker-compose.local.yml up -d --build

echo ""
echo -e "${GREEN}✅ Ambiente LOCAL iniciado!${NC}"
echo ""
echo "📊 Serviços disponíveis:"
echo "  • API: http://localhost:3001"
echo "  • Health: http://localhost:3001/health"
echo "  • MongoDB: mongodb://localhost:27017"
echo "  • Mongo Express: http://localhost:8081 (admin/admin123)"
echo ""
echo "🗄️  Banco de dados: MongoDB LOCAL (Docker)"
echo ""
echo "=================================================="
