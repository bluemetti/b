#!/bin/bash

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "=================================================="
echo "  🔄 STATUS DOS AMBIENTES"
echo "=================================================="
echo ""

# Verificar Local
if docker ps | grep -q "jwt-auth-app" | grep -v "atlas"; then
    echo -e "${GREEN}✅ LOCAL: Rodando${NC}"
    echo "   • API: http://localhost:3001"
    echo "   • MongoDB: mongodb://localhost:27017"
    echo "   • Mongo Express: http://localhost:8081"
else
    echo -e "${YELLOW}⏸️  LOCAL: Parado${NC}"
fi

echo ""

# Verificar Atlas
if docker ps | grep -q "jwt-auth-app-atlas"; then
    echo -e "${GREEN}✅ ATLAS: Rodando${NC}"
    echo "   • API: http://localhost:3002"
    echo "   • MongoDB: cluster0.zg2nt.mongodb.net (Cloud)"
else
    echo -e "${YELLOW}⏸️  ATLAS: Parado${NC}"
fi

echo ""
echo "=================================================="
echo ""
echo "💡 Comandos disponíveis:"
echo "  • ./start-local.sh  - Iniciar ambiente LOCAL"
echo "  • ./start-atlas.sh  - Iniciar ambiente ATLAS"
echo "  • ./stop-all.sh     - Parar todos os ambientes"
echo ""
