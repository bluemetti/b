#!/bin/bash

echo "=================================================="
echo "  📊 LISTANDO USUÁRIOS NO MONGODB ATLAS"
echo "=================================================="
echo ""

# Carregar variáveis de ambiente
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔗 Conectando ao MongoDB Atlas...${NC}"
echo ""

# Usar Node.js para listar usuários
node -e "
const mongoose = require('mongoose');

const MONGODB_URI = process.env.MONGODB_URI_PRODUCTION;

console.log('URI:', MONGODB_URI.replace(/\/\/[^:]+:[^@]+@/, '//****:****@'));
console.log('');

mongoose.connect(MONGODB_URI, {
    serverSelectionTimeoutMS: 5000
}).then(async () => {
    console.log('✅ Conectado ao MongoDB Atlas!');
    console.log('');
    
    const db = mongoose.connection.db;
    const usersCollection = db.collection('users');
    
    const count = await usersCollection.countDocuments();
    console.log('📊 Total de usuários:', count);
    console.log('');
    
    if (count === 0) {
        console.log('⚠️  Nenhum usuário encontrado no banco de dados.');
    } else {
        console.log('👥 Lista de usuários:');
        console.log(''.padEnd(80, '='));
        
        const users = await usersCollection.find({}).toArray();
        
        users.forEach((user, index) => {
            console.log('');
            console.log(\`Usuário \${index + 1}:\`);
            console.log(\`  ID: \${user._id}\`);
            console.log(\`  Nome: \${user.name}\`);
            console.log(\`  Email: \${user.email}\`);
            console.log(\`  Criado em: \${user.createdAt ? new Date(user.createdAt).toLocaleString('pt-BR') : 'N/A'}\`);
            console.log(''.padEnd(80, '-'));
        });
    }
    
    await mongoose.connection.close();
    process.exit(0);
}).catch(err => {
    console.error('❌ Erro ao conectar ao MongoDB Atlas:');
    console.error(err.message);
    process.exit(1);
});
"

echo ""
echo "=================================================="
echo "  ✅ Consulta concluída!"
echo "=================================================="
