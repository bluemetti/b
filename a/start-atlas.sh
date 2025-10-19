#!/bin/bash

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "=================================================="
echo "  ☁️  INICIANDO AMBIENTE ATLAS (MongoDB Cloud)"
echo "=================================================="
echo ""

# Verificar se .env existe
if [ ! -f .env ]; then
    echo -e "${RED}❌ Arquivo .env não encontrado!${NC}"
    echo "Crie o arquivo .env com MONGODB_URI_PRODUCTION"
    exit 1
fi

# Carregar variáveis
export $(cat .env | grep -v '^#' | xargs)

# Verificar se MONGODB_URI_PRODUCTION está definida
if [ -z "$MONGODB_URI_PRODUCTION" ]; then
    echo -e "${RED}❌ MONGODB_URI_PRODUCTION não está definida no .env${NC}"
    exit 1
fi

# Parar ambiente Local se estiver rodando
if docker ps -a | grep -q "jwt-auth-app" | grep -v "atlas"; then
    echo -e "${YELLOW}⏸️  Parando ambiente Local...${NC}"
    docker-compose -f docker-compose.local.yml down
    echo ""
fi

echo -e "${BLUE}🚀 Iniciando ambiente ATLAS...${NC}"
docker-compose -f docker-compose.atlas.yml up -d --build

echo ""
echo -e "${GREEN}✅ Ambiente ATLAS iniciado!${NC}"
echo ""
echo "📊 Serviços disponíveis:"
echo "  • API: http://localhost:3002"
echo "  • Health: http://localhost:3002/health"
echo ""
echo "☁️  Banco de dados: MongoDB ATLAS (Cloud)"
echo "  • Cluster: cluster0.zg2nt.mongodb.net"
echo "  • Database: jwt-auth-db"
echo ""
echo "=================================================="
