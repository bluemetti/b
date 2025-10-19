Vídeo: https://backend.daviblumetti.tech/




# 🔐 JWT Authentication Backend

Backend completo de autenticação com Node.js, TypeScript, Express, MongoDB e JWT.

## 📋 Índice

- [Funcionalidades](#-funcionalidades)
- [Tecnologias](#-tecnologias)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Instalação e Configuração](#-instalação-e-configuração)
- [Uso com Docker](#-uso-com-docker)
- [Uso sem Docker](#-uso-sem-docker)
- [Endpoints da API](#-endpoints-da-api)
- [Variáveis de Ambiente](#-variáveis-de-ambiente)
- [Testes](#-testes)
- [Deploy](#-deploy)

## ✨ Funcionalidades

### Rotas Públicas
- ✅ **POST /register** - Registro de novos usuários
- ✅ **POST /login** - Autenticação e geração de token JWT

### Rotas Protegidas
- 🔒 **GET /protected** - Rota de exemplo protegida por JWT

### Outras Rotas
- 🏥 **GET /health** - Health check com status do MongoDB

## 🚀 Tecnologias

- **Node.js** 20+
- **TypeScript** 5.9+
- **Express** 5.1+
- **MongoDB** 7.0+
- **Mongoose** 8.19+
- **JWT** (jsonwebtoken)
- **Bcrypt** para hash de senhas
- **Docker** & **Docker Compose**

## 📁 Estrutura do Projeto

```
a/
├── src/
│   ├── controllers/      # Controladores (lógica de requisição/resposta)
│   │   └── AuthController.ts
│   ├── services/         # Serviços (lógica de negócio)
│   │   └── AuthService.ts
│   ├── models/           # Modelos do MongoDB
│   │   └── User.ts
│   ├── middlewares/      # Middlewares (autenticação, validação)
│   │   ├── authMiddleware.ts
│   │   └── validationMiddleware.ts
│   ├── routes/           # Definição de rotas
│   │   └── authRoutes.ts
│   ├── database/         # Configuração do banco de dados
│   │   └── connection.ts
│   ├── app.ts           # Configuração do Express
│   └── index.ts         # Entry point da aplicação
├── requests/            # Requisições de teste (Insomnia/Postman)
│   ├── requests.yaml    # Coleção completa
│   └── *.sh            # Scripts individuais
├── Dockerfile           # Dockerfile para produção
├── docker-compose.yml   # Orquestração de containers
├── .dockerignore        # Arquivos ignorados no build
├── package.json
├── tsconfig.json
└── .env.example         # Exemplo de variáveis de ambiente
```

## 🔧 Instalação e Configuração

### Pré-requisitos

#### Opção 1: Com Docker (Recomendado)
- Docker 20+
- Docker Compose 2+

#### Opção 2: Sem Docker
- Node.js 20+
- MongoDB 7+
- npm ou yarn

### Configuração Inicial

1. **Clone o repositório**
```bash
cd a
```

2. **Crie o arquivo `.env`**
```bash
cp .env.example .env
```

3. **Edite o arquivo `.env` com suas configurações**
```bash
nano .env  # ou use seu editor preferido
```

## 🐳 Uso com Docker

### Iniciar todos os serviços

```bash
# Modo desenvolvimento (com logs visíveis)
npm run docker:dev

# Ou em modo detached (segundo plano)
npm run docker:up
```

Isso iniciará:
- **App Node.js** → http://localhost:3001
- **MongoDB** → mongodb://localhost:27017
- **Mongo Express** (UI Web) → http://localhost:8081
  - Usuário: `admin`
  - Senha: `admin123`

### Outros comandos Docker

```bash
# Ver logs da aplicação
npm run docker:logs

# Parar todos os serviços
npm run docker:down

# Reiniciar apenas a aplicação
npm run docker:restart

# Parar e remover volumes (limpa banco de dados)
npm run docker:clean

# Construir apenas a imagem
npm run docker:build
```

### Acessar o container

```bash
docker exec -it jwt-auth-app sh
```

## 💻 Uso sem Docker

### 1. Instalar dependências

```bash
npm install
```

### 2. Configurar MongoDB

Certifique-se de que o MongoDB está rodando localmente:

```bash
# Verificar se MongoDB está rodando
sudo systemctl status mongod

# Iniciar MongoDB
sudo systemctl start mongod
```

### 3. Configurar `.env`

```env
NODE_ENV=development
PORT=3001
MONGODB_URI=mongodb://localhost:27017/jwt-auth-db
JWT_SECRET=seu-segredo-super-secreto-aqui
JWT_EXPIRES_IN=24h
BCRYPT_SALT_ROUNDS=12
```

### 4. Executar em desenvolvimento

```bash
# Com hot-reload
npm run dev

# Ou compilar e executar
npm run build
npm start
```

## 📡 Endpoints da API

### Health Check

```http
GET /health
```

**Resposta de Sucesso (200)**
```json
{
  "success": true,
  "message": "Server is running!",
  "timestamp": "2025-10-19T10:30:00.000Z",
  "environment": "development",
  "database": {
    "status": "connected",
    "name": "jwt-auth-db"
  }
}
```

### Registro de Usuário

```http
POST /register
Content-Type: application/json

{
  "name": "João Silva",
  "email": "joao.silva@email.com",
  "password": "Senha@123"
}
```

**Validações:**
- `name`: mínimo 2 caracteres, máximo 50
- `email`: formato válido de email
- `password`: mínimo 8 caracteres, deve conter:
  - 1 letra maiúscula
  - 1 letra minúscula
  - 1 número
  - 1 caractere especial (@$!%*?&#)

**Resposta de Sucesso (201)**
```json
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "user": {
      "id": "67...",
      "name": "João Silva",
      "email": "joao.silva@email.com",
      "createdAt": "2025-10-19T10:30:00.000Z"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

**Erros Possíveis:**
- `422` - Validação falhou
- `422` - Email já cadastrado

### Login

```http
POST /login
Content-Type: application/json

{
  "email": "joao.silva@email.com",
  "password": "Senha@123"
}
```

**Resposta de Sucesso (200)**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": {
      "id": "67...",
      "name": "João Silva",
      "email": "joao.silva@email.com",
      "createdAt": "2025-10-19T10:30:00.000Z"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

**Erros Possíveis:**
- `404` - Usuário não encontrado
- `401` - Senha inválida
- `422` - Dados inválidos

### Rota Protegida

```http
GET /protected
Authorization: Bearer <seu-token-jwt>
```

**Resposta de Sucesso (200)**
```json
{
  "success": true,
  "message": "Acesso autorizado",
  "data": {
    "message": "Você acessou uma rota protegida com sucesso!",
    "user": {
      "userId": "67...",
      "email": "joao.silva@email.com"
    },
    "timestamp": "2025-10-19T10:30:00.000Z"
  }
}
```

**Erros Possíveis:**
- `401` - Token não fornecido
- `401` - Token inválido ou expirado

## 🔐 Variáveis de Ambiente

| Variável | Descrição | Exemplo | Obrigatória |
|----------|-----------|---------|-------------|
| `NODE_ENV` | Ambiente de execução | `development` ou `production` | Não |
| `PORT` | Porta do servidor | `3001` | Não (padrão: 3000) |
| `MONGODB_URI` | URL do MongoDB (dev/local) | `mongodb://localhost:27017/jwt-auth-db` | Sim |
| `MONGODB_URI_PRODUCTION` | URL do MongoDB (produção) | `mongodb+srv://user:pass@cluster.mongodb.net/db` | Sim (prod) |
| `JWT_SECRET` | Chave secreta do JWT | `seu-super-segredo-aqui` | Sim |
| `JWT_EXPIRES_IN` | Tempo de expiração do token | `24h`, `7d`, `30m` | Não (padrão: 24h) |
| `BCRYPT_SALT_ROUNDS` | Rounds do bcrypt | `12` | Não (padrão: 12) |

## 🧪 Testes

### Importar Coleção no Insomnia

1. Abra o Insomnia
2. Vá em **Application** → **Preferences** → **Data** → **Import Data**
3. Selecione o arquivo `requests/requests.yaml`
4. Crie um ambiente com a variável `base_url`:
   ```json
   {
     "base_url": "http://localhost:3001"
   }
   ```

### Executar Testes via Scripts

```bash
cd requests

# Executar todos os testes
./run-all-tests.sh

# Executar teste individual
./01-register-success.sh
./06-login-success.sh
```

### Cenários de Teste Incluídos

1. ✅ Cadastro bem-sucedido
2. ❌ Cadastro com email repetido
3. ❌ Cadastro com senha inválida
4. ❌ Cadastro com email inválido
5. ❌ Cadastro com JSON mal formatado
6. ✅ Login bem-sucedido
7. ❌ Login com senha inválida
8. ❌ Login com email inválido
9. ❌ Login com JSON mal formatado
10. ✅ Acesso a /protected com token válido
11. ❌ Acesso a /protected sem token
12. ❌ Acesso a /protected com token inválido

## 🌐 Deploy

### Preparação para Produção

1. **Configure variáveis de ambiente de produção**
2. **Use MongoDB Atlas** (gratuito):
   - Crie uma conta em https://www.mongodb.com/cloud/atlas
   - Crie um cluster
   - Configure IP whitelist (0.0.0.0/0 para permitir todos)
   - Copie a connection string para `MONGODB_URI_PRODUCTION`

3. **Gere um JWT_SECRET forte**:
   ```bash
   node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
   ```

### Deploy na Vercel

```bash
# Instalar Vercel CLI
npm i -g vercel

# Fazer deploy
vercel

# Deploy em produção
vercel --prod
```

**Importante**: Configure as variáveis de ambiente no painel da Vercel:
- `NODE_ENV=production`
- `MONGODB_URI_PRODUCTION`
- `JWT_SECRET`
- `JWT_EXPIRES_IN`
- `BCRYPT_SALT_ROUNDS`

### Deploy no Render

1. Conecte seu repositório GitHub
2. Configure:
   - **Build Command**: `npm run build`
   - **Start Command**: `npm start`
3. Adicione as variáveis de ambiente

### Deploy no Railway

```bash
# Instalar Railway CLI
npm i -g @railway/cli

# Login
railway login

# Inicializar projeto
railway init

# Deploy
railway up
```

## 📝 Logs

A aplicação possui logs em pontos estratégicos:

- ✅ Registro bem-sucedido
- ⚠️ Tentativa de registro com email duplicado
- ❌ Erros de validação
- ✅ Login bem-sucedido
- ⚠️ Tentativa de login com usuário não existente
- ⚠️ Tentativa de login com senha incorreta
- ✅ Token verificado com sucesso
- 🔄 Tentativas de acesso a rotas

## 🔒 Segurança

- ✅ Senhas hasheadas com bcrypt (12 rounds)
- ✅ JWT com expiração configurável
- ✅ Validação de entrada em todas as rotas
- ✅ CORS configurado
- ✅ Helmet para headers de segurança
- ✅ Password não retornado nas queries

## 📄 Licença

ISC

## 👨‍💻 Autor

Desenvolvido como projeto acadêmico.

---

**Precisa de ajuda?** Consulte a documentação completa em:
- [API_DOCS.md](./API_DOCS.md) - Documentação detalhada da API
- [DEPLOYMENT.md](./DEPLOYMENT.md) - Guia de deploy
- [QUICK_START.md](./QUICK_START.md) - Início rápido
