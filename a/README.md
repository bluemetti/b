# JWT Authentication Backend

## 📋 Descrição

API Backend desenvolvida com Node.js, TypeScript, Express e MongoDB para autenticação de usuários utilizando JWT (JSON Web Tokens). O projeto segue uma arquitetura em camadas bem estruturada e implementa todas as funcionalidades obrigatórias solicitadas.

## 🏗️ Arquitetura

O projeto está organizado seguindo a arquitetura de camadas:

```
src/
├── controllers/     # Controladores da aplicação
├── services/        # Lógica de negócio
├── models/          # Modelos do banco de dados (Mongoose)
├── routes/          # Definição das rotas
├── middlewares/     # Middlewares customizados
├── database/        # Configuração do banco de dados
└── index.ts         # Ponto de entrada da aplicação
```

## 🚀 Funcionalidades

### Rotas Públicas

- **POST /register**: Cria um novo usuário no sistema
- **POST /login**: Autentica um usuário e gera um token JWT

### Rotas Protegidas

- **GET /protected**: Rota que responde "Acesso autorizado", acessível apenas com token JWT válido

### Recursos Implementados

- ✅ Model de User com validações completas
- ✅ Senha salva como hash (bcrypt)
- ✅ Tratamento de erros adequado
- ✅ Variáveis de ambiente para configurações sensíveis
- ✅ Conexão com MongoDB (local e produção)
- ✅ Logs apropriados para todas as operações
- ✅ Validação de dados de entrada
- ✅ Middlewares de autenticação e validação

## 🛠️ Tecnologias Utilizadas

- **Node.js** - Runtime JavaScript
- **TypeScript** - Superset do JavaScript com tipagem
- **Express** - Framework web
- **MongoDB** - Banco de dados NoSQL
- **Mongoose** - ODM para MongoDB
- **bcrypt** - Hash de senhas
- **jsonwebtoken** - Geração e verificação de JWT
- **cors** - Política de CORS
- **helmet** - Segurança HTTP
- **morgan** - Logger de requisições HTTP
- **dotenv** - Gerenciamento de variáveis de ambiente

## 📦 Instalação e Configuração

### Pré-requisitos

- Node.js (v16 ou superior)
- MongoDB (local ou MongoDB Atlas)
- npm ou yarn

### Passos para instalação

1. **Clone o repositório**
```bash
git clone <url-do-repositorio>
cd jwt-auth-backend
```

2. **Instale as dependências**
```bash
npm install
```

3. **Configure as variáveis de ambiente**
```bash
cp .env.example .env
```

Edite o arquivo `.env` com suas configurações:
```env
NODE_ENV=development
PORT=3001
MONGODB_URI=mongodb://localhost:27017/jwt-auth-db
JWT_SECRET=seu-jwt-secret-super-seguro
JWT_EXPIRES_IN=24h
BCRYPT_SALT_ROUNDS=12
```

4. **Compile o TypeScript**
```bash
npm run build
```

5. **Execute a aplicação**

**Desenvolvimento (com hot reload):**
```bash
npm run dev
```

**Produção:**
```bash
npm start
```

## 🧪 Testando a API

### Usando os scripts fornecidos

Na pasta `requests/` há scripts bash para testar todos os cenários:

1. **Dê permissão de execução aos scripts:**
```bash
chmod +x requests/*.sh
```

2. **Execute todos os testes:**
```bash
cd requests
./run-all-tests.sh
```

3. **Ou execute testes individuais:**
```bash
./01-register-success.sh
./06-login-success.sh
./10-protected-with-valid-token.sh
```

### Exemplos de uso manual

#### 1. Registrar um usuário
```bash
curl -X POST http://localhost:3001/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "João Silva",
    "email": "joao@email.com",
    "password": "senha123"
  }'
```

#### 2. Fazer login
```bash
curl -X POST http://localhost:3001/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "joao@email.com",
    "password": "senha123"
  }'
```

#### 3. Acessar rota protegida
```bash
curl -X GET http://localhost:3001/protected \
  -H "Authorization: Bearer SEU_TOKEN_AQUI"
```

## 📊 Estrutura de Resposta da API

### Sucesso
```json
{
  "success": true,
  "message": "Operação realizada com sucesso",
  "data": {
    // dados da resposta
  }
}
```

### Erro
```json
{
  "success": false,
  "message": "Descrição do erro",
  "error": "CODIGO_DO_ERRO",
  "errors": [
    // array de erros detalhados (quando aplicável)
  ]
}
```

## 🔒 Segurança

- Senhas são hasheadas com bcrypt (salt rounds: 12)
- Tokens JWT com expiração configurável
- Validação rigorosa de dados de entrada
- Headers de segurança com Helmet
- Política CORS configurada
- Tratamento seguro de erros (sem exposição de dados sensíveis)

## 🌍 Variáveis de Ambiente

| Variável | Descrição | Padrão |
|----------|-----------|---------|
| `NODE_ENV` | Ambiente de execução | `development` |
| `PORT` | Porta do servidor | `3000` |
| `MONGODB_URI` | URI do MongoDB (desenvolvimento) | - |
| `MONGODB_URI_PRODUCTION` | URI do MongoDB (produção) | - |
| `JWT_SECRET` | Chave secreta para JWT | - |
| `JWT_EXPIRES_IN` | Tempo de expiração do JWT | `24h` |
| `BCRYPT_SALT_ROUNDS` | Rounds de salt do bcrypt | `12` |

## 🚀 Deploy

### MongoDB Atlas (Produção)

1. Crie uma conta no [MongoDB Atlas](https://www.mongodb.com/atlas)
2. Crie um cluster gratuito
3. Configure as credenciais de acesso
4. Atualize a variável `MONGODB_URI_PRODUCTION` no arquivo `.env`

### Heroku / Vercel / Railway

1. Configure as variáveis de ambiente na plataforma escolhida
2. Certifique-se de que `NODE_ENV=production`
3. Configure a `MONGODB_URI_PRODUCTION` com a string de conexão do Atlas

## 📝 Scripts Disponíveis

| Script | Descrição |
|--------|-----------|
| `npm run dev` | Executa em modo desenvolvimento com hot reload |
| `npm run build` | Compila o TypeScript para JavaScript |
| `npm start` | Executa a versão compilada |
| `npm run watch` | Compila TypeScript em modo watch |
| `npm run clean` | Remove a pasta dist |

## 🔍 Logs

A aplicação gera logs detalhados para:
- ✅ Conexão com banco de dados
- 🔄 Tentativas de registro e login
- 🔐 Verificações de token
- ❌ Erros e exceções
- 📊 Requisições HTTP (Morgan)

## 📋 Cenários de Teste Implementados

### Registro
- ✅ Registro bem-sucedido
- ❌ Email já existente
- ❌ Senha inválida (muito curta)
- ❌ Email inválido
- ❌ JSON mal formatado

### Login
- ✅ Login bem-sucedido
- ❌ Senha incorreta
- ❌ Email inválido/inexistente
- ❌ JSON mal formatado

### Rota Protegida
- ✅ Acesso com token válido
- ❌ Acesso sem token
- ❌ Acesso com token inválido

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença ISC. Veja o arquivo `LICENSE` para mais detalhes.

## 👥 Autor

Desenvolvido como atividade acadêmica para demonstrar conhecimentos em:
- Arquitetura de software em camadas
- Autenticação JWT
- API RESTful
- TypeScript/Node.js
- MongoDB/Mongoose
- Segurança em aplicações web
