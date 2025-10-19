# 🎯 ROTAS CORRETAS PARA USAR NO INSOMNIA

## ✅ Rotas Disponíveis

### **BASE URL**
```
https://organic-space-meme-7v9xrv7jjvp9cxpj9-3002.app.github.dev
```

---

## 📋 ENDPOINTS

### **1. Health Check**
```
GET /health
```

**URL Completa:**
```
https://organic-space-meme-7v9xrv7jjvp9cxpj9-3002.app.github.dev/health
```

**Resposta Esperada:**
```json
{
  "success": true,
  "message": "Server is running!",
  "database": {
    "status": "connected",
    "name": "jwt-auth-db"
  }
}
```

---

### **2. Register (Cadastro)**
```
POST /register
```

**URL Completa:**
```
https://organic-space-meme-7v9xrv7jjvp9cxpj9-3002.app.github.dev/register
```

**Headers:**
```
Content-Type: application/json
```

**Body (JSON):**
```json
{
  "name": "João Silva",
  "email": "joao.silva@email.com",
  "password": "Senha@123"
}
```

**Resposta Esperada:**
```json
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "user": {
      "id": "...",
      "name": "João Silva",
      "email": "joao.silva@email.com",
      "createdAt": "..."
    },
    "token": "eyJhbGciOiJIUzI1NiIs..."
  }
}
```

---

### **3. Login**
```
POST /login
```

**URL Completa:**
```
https://organic-space-meme-7v9xrv7jjvp9cxpj9-3002.app.github.dev/login
```

**Headers:**
```
Content-Type: application/json
```

**Body (JSON):**
```json
{
  "email": "joao.silva@email.com",
  "password": "Senha@123"
}
```

**Resposta Esperada:**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": {
      "id": "...",
      "name": "João Silva",
      "email": "joao.silva@email.com"
    },
    "token": "eyJhbGciOiJIUzI1NiIs..."
  }
}
```

---

### **4. Protected Route (Rota Protegida)**
```
GET /protected
```

**URL Completa:**
```
https://organic-space-meme-7v9xrv7jjvp9cxpj9-3002.app.github.dev/protected
```

**Headers:**
```
Authorization: Bearer SEU_TOKEN_AQUI
```

**Resposta Esperada:**
```json
{
  "success": true,
  "message": "Access granted to protected route",
  "data": {
    "userId": "...",
    "email": "joao.silva@email.com"
  }
}
```

---

## ❌ Rotas que NÃO EXISTEM

Estas rotas retornam **404 Not Found**:

- ❌ `GET /` (raiz)
- ❌ `GET /users`
- ❌ `POST /user`
- ❌ Qualquer outra rota não listada acima

---

## 🎬 FLUXO COMPLETO NO INSOMNIA

### **Passo 1: Health Check**
```
GET /health
```
✅ Confirma que API está rodando

---

### **Passo 2: Register**
```
POST /register
Body:
{
  "name": "Seu Nome",
  "email": "seu.email@example.com",
  "password": "SuaSenha@123"
}
```
✅ Copie o **token** retornado!

---

### **Passo 3: Configurar Token no Ambiente**

1. No Insomnia, clique no ambiente (canto superior esquerdo)
2. Clique em **"Manage Environments"**
3. No ambiente ativo, adicione o token:
```json
{
  "base_url": "https://organic-space-meme-7v9xrv7jjvp9cxpj9-3002.app.github.dev",
  "token": "COLE_O_TOKEN_AQUI"
}
```
4. Clique em **"Done"**

---

### **Passo 4: Testar Rota Protegida**
```
GET /protected
Header: Authorization: Bearer {{ _.token }}
```
✅ Deve retornar seus dados de usuário

---

## 🐛 TROUBLESHOOTING

### **❌ Erro: 404 Not Found**

**Causa:** Rota incorreta

**Soluções:**
- ✅ Verifique se está usando `/register` (não `/user` ou `/signup`)
- ✅ Verifique se está usando `/login` (não `/auth` ou `/signin`)
- ✅ Verifique se a URL termina com `/health`, `/register`, `/login` ou `/protected`

---

### **❌ Erro: 401 Unauthorized**

**Causa:** Token inválido ou ausente

**Soluções:**
- ✅ Certifique-se de fazer login/register primeiro
- ✅ Copie o token retornado
- ✅ Configure o token no ambiente do Insomnia
- ✅ Use o header: `Authorization: Bearer {{ _.token }}`

---

### **❌ Erro: 422 Unprocessable Entity**

**Causa:** Dados inválidos

**Soluções:**
- ✅ Email inválido → Use formato válido (ex: `user@email.com`)
- ✅ Senha curta → Use mínimo 8 caracteres
- ✅ Campos obrigatórios → Envie `name`, `email` e `password`

---

## 📊 RESUMO DAS 4 ROTAS

| Método | Rota | Autenticação | Descrição |
|--------|------|--------------|-----------|
| GET | /health | ❌ Não | Status da API |
| POST | /register | ❌ Não | Cadastrar usuário |
| POST | /login | ❌ Não | Fazer login |
| GET | /protected | ✅ Sim | Rota protegida (requer token) |

---

## ✨ EXEMPLO PRÁTICO

### **1. Cadastrar:**
```bash
POST /register
{
  "name": "Maria Santos",
  "email": "maria@email.com",
  "password": "Senha@456"
}
```

### **2. Resposta (copie o token):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### **3. Acessar rota protegida:**
```bash
GET /protected
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

---

**🎉 Pronto! Agora você sabe exatamente quais rotas usar!**
