# 🚀 Guia de Deploy - Passo a Passo

## 📋 O QUE VOCÊ PRECISA FAZER

### PARTE 1: MongoDB Atlas (Banco de Dados em Nuvem)

#### Passo 1: Criar Conta no MongoDB Atlas
1. Acesse: https://www.mongodb.com/cloud/atlas/register
2. Crie uma conta gratuita
3. Confirme seu email

#### Passo 2: Criar Cluster
1. Clique em "Build a Database"
2. Escolha **FREE** (M0 Sandbox)
3. Escolha o provedor: **AWS** ou **Google Cloud**
4. Escolha a região mais próxima (ex: São Paulo, Virginia, etc)
5. Clique em "Create Cluster"
6. Aguarde 3-5 minutos até o cluster ser criado

#### Passo 3: Configurar Acesso ao Banco
1. Na tela "Security Quickstart":
   - **Username**: escolha um username (ex: `admin`)
   - **Password**: crie uma senha forte (salve em lugar seguro!)
   - Clique em "Create User"

2. **IP Whitelist**:
   - Clique em "Add IP Address"
   - Clique em "Allow Access from Anywhere"
   - Isso adiciona `0.0.0.0/0` (permite todas as IPs)
   - Clique em "Confirm"

#### Passo 4: Obter Connection String
1. Clique em "Connect" no seu cluster
2. Escolha "Connect your application"
3. Driver: **Node.js**
4. Version: **6.8 or later**
5. Copie a connection string, será algo como:
   ```
   mongodb+srv://admin:<password>@cluster0.xxxxx.mongodb.net/?retryWrites=true&w=majority
   ```
6. **IMPORTANTE:** Substitua `<password>` pela senha real que você criou
7. Adicione o nome do banco no final: `...mongodb.net/jwt-auth-db?retryWrites=true&w=majority`

#### Passo 5: Testar Conexão Local com MongoDB Atlas
```bash
# No seu terminal local, edite o .env
nano .env

# Mude temporariamente para testar:
NODE_ENV=production
MONGODB_URI_PRODUCTION=mongodb+srv://admin:SUA_SENHA_AQUI@cluster0.xxxxx.mongodb.net/jwt-auth-db?retryWrites=true&w=majority

# Pare o Docker
docker-compose down

# Inicie novamente
docker-compose up -d

# Teste
curl http://localhost:3001/health

# Cadastre um usuário de teste
curl -X POST http://localhost:3001/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Usuario Producao",
    "email": "prod@email.com",
    "password": "Senha@123"
  }'

# Volte o .env para development depois
```

---

### PARTE 2: Deploy no Render (Recomendado - Mais Fácil)

#### Por que Render?
- ✅ Gratuito
- ✅ Suporta Docker
- ✅ Deploy automático do GitHub
- ✅ Mais fácil que Vercel para Node.js com MongoDB

#### Passo 1: Preparar Repositório GitHub
```bash
# No terminal local
cd /workspaces/b/a

# Adicionar todos os arquivos
git add .

# Commit
git commit -m "feat: JWT authentication backend with Docker"

# Push para GitHub
git push origin main
```

#### Passo 2: Criar Conta no Render
1. Acesse: https://render.com/
2. Clique em "Get Started"
3. Faça login com GitHub

#### Passo 3: Criar Web Service
1. No dashboard, clique em "New +"
2. Escolha "Web Service"
3. Conecte seu repositório GitHub
4. Selecione o repositório `b`
5. Configure:
   - **Name**: `jwt-auth-backend`
   - **Region**: escolha a mais próxima
   - **Branch**: `main`
   - **Root Directory**: `a` (importante!)
   - **Runtime**: `Docker`
   - **Instance Type**: `Free`

#### Passo 4: Configurar Variáveis de Ambiente
Na seção "Environment Variables", adicione:

```
NODE_ENV=production
PORT=3001
MONGODB_URI_PRODUCTION=mongodb+srv://admin:SUA_SENHA@cluster0.xxxxx.mongodb.net/jwt-auth-db?retryWrites=true&w=majority
JWT_SECRET=e64c60b2ce4429ceb041a6f19058f726f55f0eb56b452fcba2ac4e32957fa5c9
JWT_EXPIRES_IN=24h
BCRYPT_SALT_ROUNDS=12
```

#### Passo 5: Deploy
1. Clique em "Create Web Service"
2. Aguarde o build (5-10 minutos)
3. Quando terminar, você terá uma URL tipo:
   `https://jwt-auth-backend.onrender.com`

#### Passo 6: Testar em Produção
```bash
# Teste health
curl https://jwt-auth-backend.onrender.com/health

# Cadastre usuário
curl -X POST https://jwt-auth-backend.onrender.com/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Usuario Prod",
    "email": "prod.teste@email.com",
    "password": "Senha@123"
  }'

# Faça login
curl -X POST https://jwt-auth-backend.onrender.com/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "prod.teste@email.com",
    "password": "Senha@123"
  }'
```

---

### ALTERNATIVA: Deploy na Vercel

A Vercel é mais complicada para Node.js + MongoDB, mas é possível:

#### Criar vercel.json
```json
{
  "version": 2,
  "builds": [
    {
      "src": "a/dist/index.js",
      "use": "@vercel/node"
    }
  ],
  "routes": [
    {
      "src": "/(.*)",
      "dest": "a/dist/index.js"
    }
  ]
}
```

#### Deploy
```bash
npm i -g vercel
cd /workspaces/b
vercel
```

**Problema:** Vercel tem timeout de 10s para requests no plano free, pode não ser ideal.

---

### PARTE 3: Testar Tudo

#### Checklist de Testes em Produção:
- [ ] Health check responde
- [ ] Cadastro funciona
- [ ] Login funciona
- [ ] Rota protegida com token funciona
- [ ] Erros de validação funcionam
- [ ] Verificar MongoDB Atlas mostra usuários

---

### PARTE 4: Gravar Vídeo (MAX 2 MINUTOS)

#### Estrutura do Vídeo:

**0:00-0:10 - Introdução**
- Mostrar rosto + tela
- "Olá, vou demonstrar minha aplicação JWT Auth Backend"

**0:10-0:40 - Testes Locais**
- Abrir Insomnia/Postman
- Executar 3-4 requests principais:
  - Cadastro
  - Login
  - Rota protegida
  - Um erro (email duplicado)

**0:40-1:00 - Banco de Dados Local**
- Abrir http://localhost:8081
- Login no Mongo Express
- Mostrar coleção `users`
- Mostrar 2-3 usuários cadastrados

**1:00-1:30 - Testes em Produção**
- Executar mesmas requests na URL de produção
- Mostrar que funciona

**1:30-1:50 - Banco de Dados Produção**
- Abrir MongoDB Atlas
- Mostrar cluster
- Clicar em "Browse Collections"
- Mostrar usuários em produção

**1:50-2:00 - Conclusão**
- "Aplicação funcionando local e em produção, obrigado!"

#### Ferramentas para Gravar:
- **Windows**: ClipChamp (gratuito)
- **Mac**: QuickTime ou OBS
- **Linux**: OBS Studio
- **Online**: Loom (gratuito, 5min)

#### Configuração da Câmera:
- Usar ferramenta de "Picture in Picture" ou gravar webcam separada
- Se usar OBS: adicione "Video Capture Device" como fonte

---

### PARTE 5: Finalizar Submissão

#### Adicionar Vídeo ao README
1. Faça upload do vídeo no YouTube (não listado)
2. Edite o README.md e adicione no topo:

```markdown
## 🎥 Vídeo Demonstrativo

[![Vídeo Demo](https://img.youtube.com/vi/VIDEO_ID/0.jpg)](https://www.youtube.com/watch?v=VIDEO_ID)

**Link direto:** https://www.youtube.com/watch?v=VIDEO_ID
```

#### Criar Release no GitHub
```bash
git add .
git commit -m "docs: add video demo"
git push origin main

# Criar tag
git tag -a v1.0.0 -m "Release v1.0.0 - JWT Auth Backend"
git push origin v1.0.0
```

No GitHub:
1. Vá em "Releases"
2. "Create a new release"
3. Tag: `v1.0.0`
4. Title: "JWT Auth Backend v1.0.0"
5. Description: Cole os links e informações
6. "Publish release"

---

## 📝 INFORMAÇÕES PARA SUBMETER

**Link do Repositório:**
```
https://github.com/bluemetti/b
```

**Link do Backend em Produção:**
```
https://jwt-auth-backend.onrender.com
(ou sua URL do Render)
```

**Link do Vídeo:**
```
https://www.youtube.com/watch?v=SEU_VIDEO_ID
```

---

## 🆘 PROBLEMAS COMUNS

### MongoDB Atlas não conecta
- Verifique se IP `0.0.0.0/0` está na whitelist
- Verifique se a senha está correta na connection string
- Teste a connection string localmente primeiro

### Render não faz build
- Verifique se `Root Directory` está como `a`
- Verifique logs de build no Render
- Certifique-se que Dockerfile está correto

### Aplicação dá timeout no Render (free tier)
- Normal na primeira request (cold start)
- Aguarde 30-60s e tente novamente

---

## ✅ CHECKLIST FINAL

Antes de submeter, verifique:

- [ ] MongoDB Atlas configurado e funcionando
- [ ] Aplicação deployada (Render ou Vercel)
- [ ] Health check funcionando em produção
- [ ] Cadastro/Login funcionando em produção
- [ ] Usuários aparecendo no MongoDB Atlas
- [ ] Vídeo gravado (max 2min, rosto + tela)
- [ ] Vídeo publicado (YouTube/Drive)
- [ ] Link do vídeo no README.md
- [ ] Tag/Release v1.0.0 criada no GitHub
- [ ] Todos os links funcionando

---

**BOA SORTE! 🚀**
