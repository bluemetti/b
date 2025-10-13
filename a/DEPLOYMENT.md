# 🌐 Deployment Guide

## 📋 Opções de Deploy

### 1. Heroku

#### Preparação
```bash
# Instalar Heroku CLI
# Fazer login
heroku login

# Criar aplicação
heroku create seu-app-name

# Configurar variáveis de ambiente
heroku config:set NODE_ENV=production
heroku config:set JWT_SECRET=sua-chave-super-secreta
heroku config:set MONGODB_URI_PRODUCTION=sua-string-mongodb-atlas
heroku config:set PORT=
```

#### Deploy
```bash
git add .
git commit -m "Ready for production"
git push heroku main
```

### 2. Vercel

#### Preparação
```bash
# Instalar Vercel CLI
npm i -g vercel

# Deploy
vercel
```

#### Configuração (vercel.json)
```json
{
  "version": 2,
  "builds": [
    {
      "src": "dist/index.js",
      "use": "@vercel/node"
    }
  ],
  "routes": [
    {
      "src": "/(.*)",
      "dest": "/dist/index.js"
    }
  ],
  "env": {
    "NODE_ENV": "production"
  }
}
```

### 3. Railway

#### Preparação
```bash
# Instalar Railway CLI
npm install -g @railway/cli

# Login e deploy
railway login
railway link
railway up
```

### 4. Render

1. Conecte seu repositório GitHub
2. Configure as variáveis de ambiente:
   - `NODE_ENV=production`
   - `JWT_SECRET=sua-chave-secreta`
   - `MONGODB_URI_PRODUCTION=sua-string-mongodb`
3. Build Command: `npm run build`
4. Start Command: `npm start`

### 5. DigitalOcean App Platform

1. Crie uma nova App
2. Conecte seu repositório
3. Configure as variáveis de ambiente
4. Build Command: `npm run build`
5. Run Command: `npm start`

## 🗄️ MongoDB Atlas Setup

### 1. Criar Conta e Cluster
1. Acesse [MongoDB Atlas](https://www.mongodb.com/atlas)
2. Crie uma conta gratuita
3. Crie um cluster gratuito (M0)
4. Escolha a região mais próxima

### 2. Configurar Acesso
1. **Database Access**: Crie um usuário com senha
2. **Network Access**: 
   - Para desenvolvimento: Adicione seu IP
   - Para produção: Adicione `0.0.0.0/0` (permitir de qualquer lugar)

### 3. Obter String de Conexão
1. Clique em "Connect" no seu cluster
2. Escolha "Connect your application"
3. Copie a string de conexão
4. Substitua `<password>` pela senha do usuário
5. Substitua `<dbname>` pelo nome do seu banco

**Exemplo:**
```
mongodb+srv://usuario:senha@cluster0.abcde.mongodb.net/jwt-auth-db?retryWrites=true&w=majority
```

## 🔧 Configurações de Produção

### Variáveis de Ambiente Obrigatórias

```env
NODE_ENV=production
PORT=3000
MONGODB_URI_PRODUCTION=mongodb+srv://user:pass@cluster.mongodb.net/dbname
JWT_SECRET=sua-chave-super-secreta-minimo-32-caracteres
JWT_EXPIRES_IN=24h
BCRYPT_SALT_ROUNDS=12
```

### Otimizações para Produção

#### 1. package.json - Scripts de Produção
```json
{
  "scripts": {
    "build": "tsc",
    "start": "node dist/index.js",
    "postinstall": "npm run build"
  }
}
```

#### 2. Logs em Produção
- Configure logs estruturados
- Use serviços como Winston para logs avançados
- Configure alertas para erros críticos

#### 3. Monitoramento
- Configure health checks
- Use serviços como New Relic, DataDog, ou Sentry
- Configure alertas de uptime

### Dockerfile (Opcional)

```dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .
RUN npm run build

EXPOSE 3000

USER node

CMD ["npm", "start"]
```

### docker-compose.yml (Para desenvolvimento local com MongoDB)

```yaml
version: '3.8'
services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
      - MONGODB_URI=mongodb://mongo:27017/jwt-auth-db
      - JWT_SECRET=dev-secret-key
    depends_on:
      - mongo

  mongo:
    image: mongo:6
    ports:
      - "27017:27017"
    volumes:
      - mongo_data:/data/db

volumes:
  mongo_data:
```

## 🔍 Checklist de Deploy

### Antes do Deploy
- [ ] Todas as variáveis de ambiente configuradas
- [ ] MongoDB Atlas configurado e acessível
- [ ] JWT_SECRET definido (mínimo 32 caracteres)
- [ ] Build sem erros (`npm run build`)
- [ ] Testes passando
- [ ] .env adicionado ao .gitignore

### Após o Deploy
- [ ] Health check funcionando
- [ ] Registro de usuário funcionando
- [ ] Login funcionando
- [ ] Rota protegida funcionando
- [ ] Logs sendo gerados corretamente
- [ ] Conexão com banco funcionando

### Comandos de Verificação

```bash
# 1. Verificar saúde da API
curl https://sua-app.herokuapp.com/health

# 2. Testar registro
curl -X POST https://sua-app.herokuapp.com/register \
  -H "Content-Type: application/json" \
  -d '{"name":"Test","email":"test@email.com","password":"test123"}'

# 3. Testar login
curl -X POST https://sua-app.herokuapp.com/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@email.com","password":"test123"}'

# 4. Testar rota protegida (substitua TOKEN)
curl -X GET https://sua-app.herokuapp.com/protected \
  -H "Authorization: Bearer TOKEN"
```

## 🚨 Troubleshooting de Deploy

### Erro: "Cannot find module"
**Causa:** Dependências não instaladas corretamente
**Solução:** Verificar se `npm ci` ou `npm install` está sendo executado

### Erro: "MongoDB connection failed"
**Causa:** String de conexão incorreta ou IP não liberado
**Solução:** Verificar string de conexão e whitelist de IPs no Atlas

### Erro: "JWT_SECRET is not defined"
**Causa:** Variável de ambiente não configurada
**Solução:** Configurar variável no painel da plataforma de deploy

### Erro: "Port already in use"
**Causa:** Porta hardcoded no código
**Solução:** Usar `process.env.PORT` no código

### Build falha
**Causa:** Erros de TypeScript
**Solução:** Executar `npm run build` localmente e corrigir erros

## 📊 Monitoring e Logs

### Exemplo com Winston (Opcional)

```bash
npm install winston
```

```typescript
// src/utils/logger.ts
import winston from 'winston';

const logger = winston.createLogger({
  level: process.env.NODE_ENV === 'production' ? 'info' : 'debug',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  transports: [
    new winston.transports.Console(),
    ...(process.env.NODE_ENV === 'production' 
      ? [new winston.transports.File({ filename: 'error.log', level: 'error' })]
      : []
    )
  ]
});

export default logger;
```

### URLs de Exemplo

Depois do deploy, sua API estará disponível em URLs como:
- Heroku: `https://seu-app-name.herokuapp.com`
- Vercel: `https://seu-app-name.vercel.app`
- Railway: `https://seu-app-name.up.railway.app`
- Render: `https://seu-app-name.onrender.com`
