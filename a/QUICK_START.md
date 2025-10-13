# 🚀 Quick Start Guide

## 1. Instalação Rápida

```powershell
# 1. Instalar dependências
npm install

# 2. Copiar arquivo de ambiente
copy .env.example .env

# 3. Compilar o projeto
npm run build
```

## 2. Iniciar Servidor

```powershell
# Desenvolvimento (com hot reload)
npm run dev

# Produção
npm start
```

## 3. Testar a API

### Opção 1: Scripts PowerShell (Windows)
```powershell
cd requests
.\run-tests.ps1
```

### Opção 2: Scripts Bash (Linux/Mac)
```bash
cd requests
chmod +x *.sh
./run-all-tests.sh
```

### Opção 3: Teste Manual
```powershell
# 1. Registrar usuário
curl -X POST http://localhost:3000/register -H "Content-Type: application/json" -d '{"name":"João","email":"joao@email.com","password":"senha123"}'

# 2. Fazer login
curl -X POST http://localhost:3000/login -H "Content-Type: application/json" -d '{"email":"joao@email.com","password":"senha123"}'

# 3. Acessar rota protegida (substitua SEU_TOKEN pelo token obtido no login)
curl -X GET http://localhost:3000/protected -H "Authorization: Bearer SEU_TOKEN"
```

## 4. Verificar Saúde da API

```
GET http://localhost:3000/health
```

## 5. Configuração do MongoDB

### Local (desenvolvimento)
- Instale o MongoDB localmente
- Configure `MONGODB_URI=mongodb://localhost:27017/jwt-auth-db` no `.env`

### MongoDB Atlas (produção)
- Crie conta no MongoDB Atlas
- Configure `MONGODB_URI_PRODUCTION` no `.env`

## 6. Estrutura das Rotas

| Método | Rota | Descrição | Auth |
|--------|------|-----------|------|
| GET | `/health` | Status da API | ❌ |
| POST | `/register` | Registrar usuário | ❌ |
| POST | `/login` | Login de usuário | ❌ |
| GET | `/protected` | Rota protegida | ✅ |

## 7. Troubleshooting

### Erro de conexão MongoDB
```
❌ Error connecting to MongoDB
```
**Solução:** Verifique se o MongoDB está rodando ou se a string de conexão está correta.

### Erro de JWT_SECRET
```
❌ JWT_SECRET is not defined
```
**Solução:** Configure a variável `JWT_SECRET` no arquivo `.env`.

### Porta em uso
```
❌ Port 3000 is already in use
```
**Solução:** Mude a `PORT` no `.env` ou pare o processo que está usando a porta 3000.

## 8. Scripts Disponíveis

```json
{
  "dev": "nodemon src/index.ts",
  "build": "tsc",
  "start": "node dist/index.js",
  "watch": "tsc -w",
  "clean": "rimraf dist"
}
```
