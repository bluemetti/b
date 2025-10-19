# 🐳 Guia Completo Docker - JWT Authentication Backend

Este guia explica passo a passo como usar Docker para executar a aplicação, desde a instalação até o uso avançado.

## 📋 Índice

1. [Pré-requisitos](#-pré-requisitos)
2. [Instalação do Docker](#-instalação-do-docker)
3. [Configuração Inicial](#-configuração-inicial)
4. [Iniciando a Aplicação](#-iniciando-a-aplicação)
5. [Verificando Status](#-verificando-status)
6. [Acessando Serviços](#-acessando-serviços)
7. [Gerenciamento de Containers](#-gerenciamento-de-containers)
8. [Logs e Debugging](#-logs-e-debugging)
9. [Banco de Dados](#-banco-de-dados)
10. [Comandos Úteis](#-comandos-úteis)
11. [Solução de Problemas](#-solução-de-problemas)

## 🔧 Pré-requisitos

### O que você precisa ter instalado:

- **Docker** 20.10 ou superior
- **Docker Compose** 2.0 ou superior
- **Git** (para clonar o repositório)

## 📥 Instalação do Docker

### Ubuntu/Debian

```bash
# Atualizar pacotes
sudo apt update

# Instalar dependências
sudo apt install apt-transport-https ca-certificates curl software-properties-common

# Adicionar chave GPG do Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Adicionar repositório
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Instalar Docker
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Verificar instalação
docker --version
docker compose version
```

### macOS

```bash
# Instalar via Homebrew
brew install --cask docker

# Ou baixar Docker Desktop
# https://www.docker.com/products/docker-desktop
```

### Windows

1. Baixe o Docker Desktop: https://www.docker.com/products/docker-desktop
2. Execute o instalador
3. Reinicie o computador
4. Verifique no terminal:
   ```cmd
   docker --version
   docker compose version
   ```

### Adicionar usuário ao grupo Docker (Linux)

```bash
# Adicionar seu usuário ao grupo docker
sudo usermod -aG docker $USER

# Aplicar mudanças (ou faça logout/login)
newgrp docker

# Testar sem sudo
docker ps
```

## ⚙️ Configuração Inicial

### 1. Navegar para o diretório do projeto

```bash
cd a
```

### 2. Criar arquivo de ambiente

```bash
# Copiar exemplo
cp .env.example .env

# Editar (use nano, vim ou qualquer editor)
nano .env
```

### 3. Configurar variáveis de ambiente

Edite o arquivo `.env`:

```env
NODE_ENV=development
PORT=3001

# Para uso com Docker, use o nome do serviço 'mongodb'
MONGODB_URI=mongodb://mongodb:27017/jwt-auth-db

# Para produção (MongoDB Atlas)
MONGODB_URI_PRODUCTION=mongodb+srv://user:password@cluster.mongodb.net/jwt-auth-db

# Gere uma chave forte!
JWT_SECRET=sua-chave-secreta-super-forte-aqui-minimo-32-caracteres
JWT_EXPIRES_IN=24h

BCRYPT_SALT_ROUNDS=12
```

**⚠️ IMPORTANTE:** Gere um JWT_SECRET forte:

```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

## 🚀 Iniciando a Aplicação

### Método 1: Usar scripts npm (Recomendado)

```bash
# Iniciar todos os serviços (em segundo plano)
npm run docker:up

# Ou visualizar logs em tempo real
npm run docker:dev
```

### Método 2: Usar Docker Compose diretamente

```bash
# Iniciar em modo detached (segundo plano)
docker-compose up -d

# Ou com logs visíveis
docker-compose up
```

### O que acontece ao iniciar?

1. ✅ Baixa imagens necessárias (primeira vez)
2. ✅ Cria rede interna `jwt-auth-network`
3. ✅ Inicia MongoDB na porta 27017
4. ✅ Inicia Mongo Express na porta 8081
5. ✅ Constrói e inicia a aplicação Node.js na porta 3001

## 🔍 Verificando Status

### Ver containers em execução

```bash
docker ps
```

Você deve ver 3 containers:
- `jwt-auth-app` - Aplicação Node.js
- `jwt-auth-mongodb` - Banco de dados
- `jwt-auth-mongo-express` - Interface web do MongoDB

### Verificar logs

```bash
# Logs da aplicação
npm run docker:logs

# Ou logs de um serviço específico
docker-compose logs app
docker-compose logs mongodb
docker-compose logs mongo-express

# Logs em tempo real (siga)
docker-compose logs -f app
```

### Verificar saúde dos containers

```bash
# Status de todos os serviços
docker-compose ps

# Verificar uso de recursos
docker stats
```

## 🌐 Acessando Serviços

### 1. Aplicação Node.js

```bash
# Health check
curl http://localhost:3001/health

# Ou no navegador
http://localhost:3001/health
```

### 2. Mongo Express (Interface Web)

```
URL: http://localhost:8081
Usuário: admin
Senha: admin123
```

Aqui você pode:
- ✅ Visualizar bancos de dados
- ✅ Ver coleções (users)
- ✅ Visualizar documentos
- ✅ Executar queries

### 3. MongoDB Direto

Se quiser conectar via cliente MongoDB:

```bash
# Via mongosh (se instalado)
mongosh mongodb://localhost:27017/jwt-auth-db

# Via Docker
docker exec -it jwt-auth-mongodb mongosh jwt-auth-db
```

## 🎮 Gerenciamento de Containers

### Parar serviços

```bash
# Método 1: npm
npm run docker:down

# Método 2: docker-compose
docker-compose down
```

### Reiniciar serviços

```bash
# Reiniciar apenas a aplicação
npm run docker:restart

# Reiniciar tudo
docker-compose restart

# Reiniciar serviço específico
docker-compose restart mongodb
```

### Reconstruir containers

```bash
# Reconstruir e iniciar
docker-compose up -d --build

# Ou apenas construir
npm run docker:build
```

### Limpar tudo (incluindo dados)

```bash
# Parar e remover volumes (⚠️ APAGA BANCO DE DADOS)
npm run docker:clean

# Ou manualmente
docker-compose down -v
```

## 📊 Logs e Debugging

### Ver logs em tempo real

```bash
# Todos os serviços
docker-compose logs -f

# Apenas app
docker-compose logs -f app

# Últimas 100 linhas
docker-compose logs --tail=100 app
```

### Acessar shell do container

```bash
# Shell da aplicação
docker exec -it jwt-auth-app sh

# Shell do MongoDB
docker exec -it jwt-auth-mongodb mongosh

# Shell do Mongo Express
docker exec -it jwt-auth-mongo-express sh
```

### Inspecionar container

```bash
# Detalhes completos
docker inspect jwt-auth-app

# IP do container
docker inspect jwt-auth-app | grep IPAddress

# Variáveis de ambiente
docker exec jwt-auth-app env
```

## 💾 Banco de Dados

### Visualizar dados

#### Via Mongo Express (navegador)
1. Acesse http://localhost:8081
2. Login: `admin` / `admin123`
3. Clique em `jwt-auth-db`
4. Clique em `users`

#### Via Terminal

```bash
# Acessar MongoDB shell
docker exec -it jwt-auth-mongodb mongosh jwt-auth-db

# Comandos úteis no mongosh:
db.users.find().pretty()           # Ver todos os usuários
db.users.countDocuments()          # Contar usuários
db.users.findOne()                 # Ver um usuário
db.users.deleteMany({})            # Apagar todos (cuidado!)
```

### Backup do banco

```bash
# Backup
docker exec jwt-auth-mongodb mongodump --db jwt-auth-db --out /tmp/backup

# Copiar backup para host
docker cp jwt-auth-mongodb:/tmp/backup ./backup-$(date +%Y%m%d)
```

### Restaurar backup

```bash
# Copiar backup para container
docker cp ./backup-20251019 jwt-auth-mongodb:/tmp/restore

# Restaurar
docker exec jwt-auth-mongodb mongorestore --db jwt-auth-db /tmp/restore/jwt-auth-db
```

## 🛠️ Comandos Úteis

### Limpeza geral

```bash
# Remover containers parados
docker container prune

# Remover imagens não usadas
docker image prune

# Remover volumes não usados
docker volume prune

# Limpeza completa (⚠️ cuidado)
docker system prune -a
```

### Monitoramento

```bash
# Ver uso de recursos
docker stats

# Ver redes
docker network ls

# Ver volumes
docker volume ls

# Inspecionar rede
docker network inspect jwt-auth-network
```

### Atualizar aplicação

```bash
# Após mudanças no código
npm run docker:down
npm run docker:build
npm run docker:up
```

## 🐛 Solução de Problemas

### Problema: Container não inicia

```bash
# Ver logs de erro
docker-compose logs app

# Verificar se porta está em uso
sudo lsof -i :3001
sudo lsof -i :27017

# Matar processo na porta
sudo kill -9 $(sudo lsof -t -i:3001)
```

### Problema: Erro de conexão com MongoDB

```bash
# Verificar se MongoDB está rodando
docker ps | grep mongodb

# Ver logs do MongoDB
docker-compose logs mongodb

# Reiniciar MongoDB
docker-compose restart mongodb

# Verificar conectividade
docker exec jwt-auth-app ping mongodb
```

### Problema: Aplicação não conecta ao banco

Verifique o `.env`:
```env
# ERRADO (para Docker):
MONGODB_URI=mongodb://localhost:27017/jwt-auth-db

# CORRETO (para Docker):
MONGODB_URI=mongodb://mongodb:27017/jwt-auth-db
```

### Problema: Porta já em uso

```bash
# Linux/macOS
sudo lsof -i :3001
sudo kill -9 PID_DO_PROCESSO

# Windows (PowerShell)
netstat -ano | findstr :3001
taskkill /PID PID_DO_PROCESSO /F
```

### Problema: Permissão negada

```bash
# Adicionar usuário ao grupo docker
sudo usermod -aG docker $USER

# Relogar ou executar
newgrp docker
```

### Problema: Imagem não atualiza após mudanças

```bash
# Forçar rebuild sem cache
docker-compose build --no-cache
docker-compose up -d
```

### Problema: Volumes com dados antigos

```bash
# Remover volumes e reiniciar
docker-compose down -v
docker-compose up -d
```

## 📦 Volumes Persistentes

Os dados são armazenados em volumes Docker:

```bash
# Listar volumes
docker volume ls | grep jwt-auth

# Inspecionar volume
docker volume inspect a_mongodb_data

# Localização no sistema (Linux)
sudo ls -la /var/lib/docker/volumes/a_mongodb_data/_data
```

## 🔄 Workflow de Desenvolvimento

### Desenvolvimento local com hot-reload

Para habilitar hot-reload, edite `docker-compose.yml` e descomente:

```yaml
volumes:
  - ./src:/app/src
  - ./nodemon.json:/app/nodemon.json
```

Depois:
```bash
docker-compose down
docker-compose up -d
```

### Testar mudanças

```bash
# 1. Fazer mudanças no código
# 2. Reconstruir
docker-compose up -d --build

# 3. Ver logs
docker-compose logs -f app

# 4. Testar
curl http://localhost:3001/health
```

## 📚 Referências

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [MongoDB Docker Image](https://hub.docker.com/_/mongo)
- [Node.js Docker Best Practices](https://github.com/nodejs/docker-node/blob/main/docs/BestPractices.md)

---

**💡 Dica:** Mantenha o Docker Desktop aberto no Windows/macOS para melhor performance!

**🔐 Segurança:** Nunca commite o arquivo `.env` com credenciais reais!

**📊 Monitoramento:** Use `docker stats` regularmente para verificar uso de recursos!
