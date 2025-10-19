#!/bin/bash

# Script para testar conexão com MongoDB Atlas
# Usage: ./test-mongodb-atlas.sh "sua_connection_string"

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  TESTE DE CONEXÃO MONGODB ATLAS${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

if [ -z "$1" ]; then
    echo -e "${RED}❌ Erro: Connection string não fornecida${NC}"
    echo ""
    echo "Usage:"
    echo "  ./test-mongodb-atlas.sh \"mongodb+srv://user:pass@cluster.mongodb.net/dbname\""
    echo ""
    exit 1
fi

CONNECTION_STRING="$1"

echo -e "${YELLOW}Connection String:${NC} ${CONNECTION_STRING:0:50}...${NC}"
echo ""

# Criar arquivo temporário .env para teste
echo -e "${BLUE}[1/4]${NC} Criando configuração temporária..."
cat > .env.test << EOF
NODE_ENV=production
PORT=3001
MONGODB_URI_PRODUCTION=$CONNECTION_STRING
JWT_SECRET=e64c60b2ce4429ceb041a6f19058f726f55f0eb56b452fcba2ac4e32957fa5c9
JWT_EXPIRES_IN=24h
BCRYPT_SALT_ROUNDS=12
EOF

echo -e "${GREEN}✓ Configuração criada${NC}"
echo ""

# Testar conexão com MongoDB
echo -e "${BLUE}[2/4]${NC} Testando conexão com MongoDB..."

# Criar script Node.js temporário para testar conexão
cat > test-connection.js << 'EOF'
const mongoose = require('mongoose');

const connectionString = process.argv[2];

console.log('Tentando conectar ao MongoDB...');

mongoose.connect(connectionString, {
    serverSelectionTimeoutMS: 10000
})
.then(() => {
    console.log('✓ Conexão bem-sucedida!');
    console.log('Database:', mongoose.connection.name);
    return mongoose.connection.close();
})
.then(() => {
    console.log('✓ Conexão fechada com sucesso');
    process.exit(0);
})
.catch(err => {
    console.error('✗ Erro de conexão:', err.message);
    process.exit(1);
});
EOF

if node test-connection.js "$CONNECTION_STRING" 2>&1; then
    echo -e "${GREEN}✓ Conexão com MongoDB Atlas estabelecida!${NC}"
    echo ""
else
    echo -e "${RED}✗ Falha na conexão${NC}"
    echo ""
    echo -e "${YELLOW}Possíveis problemas:${NC}"
    echo "  1. Senha incorreta na connection string"
    echo "  2. IP não está na whitelist (adicione 0.0.0.0/0)"
    echo "  3. Nome do banco de dados incorreto"
    echo "  4. Cluster ainda não está pronto (aguarde alguns minutos)"
    echo ""
    rm -f .env.test test-connection.js
    exit 1
fi

# Testar com Docker
echo -e "${BLUE}[3/4]${NC} Parando containers Docker atuais..."
docker-compose down > /dev/null 2>&1
echo -e "${GREEN}✓ Containers parados${NC}"
echo ""

echo -e "${BLUE}[4/4]${NC} Iniciando aplicação com MongoDB Atlas..."

# Copiar .env.test para .env
cp .env.test .env

# Iniciar Docker com nova configuração
if docker-compose up -d > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Aplicação iniciada${NC}"
    echo ""
    
    # Aguardar aplicação iniciar
    echo "Aguardando aplicação inicializar (10s)..."
    sleep 10
    
    # Testar health check
    echo ""
    echo -e "${BLUE}Testando Health Check...${NC}"
    HEALTH_RESPONSE=$(curl -s http://localhost:3001/health)
    
    if echo "$HEALTH_RESPONSE" | grep -q "connected"; then
        echo -e "${GREEN}✓ Health check OK!${NC}"
        echo ""
        echo "$HEALTH_RESPONSE" | jq .
        echo ""
        echo -e "${GREEN}========================================${NC}"
        echo -e "${GREEN}  🎉 MONGODB ATLAS CONFIGURADO! 🎉${NC}"
        echo -e "${GREEN}========================================${NC}"
        echo ""
        echo "Sua aplicação está rodando com MongoDB Atlas!"
        echo ""
    else
        echo -e "${RED}✗ Health check falhou${NC}"
        echo "Resposta: $HEALTH_RESPONSE"
        echo ""
        echo "Verificando logs..."
        docker-compose logs app | tail -20
    fi
else
    echo -e "${RED}✗ Falha ao iniciar aplicação${NC}"
    echo ""
    echo "Verificando logs..."
    docker-compose logs app | tail -20
fi

# Limpar arquivos temporários
rm -f test-connection.js .env.test

echo ""
echo -e "${YELLOW}Nota:${NC} O arquivo .env foi atualizado com a connection string do Atlas"
echo "      Para voltar ao MongoDB local, execute: ./quick-start.sh"
