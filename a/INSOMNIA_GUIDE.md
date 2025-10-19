# 📦 GUIA DE IMPORTAÇÃO - INSOMNIA

## 🎯 Como Importar a Coleção no Insomnia

### **Passo 1: Abrir o Insomnia**
1. Abra o **Insomnia** no seu computador
2. Se não tiver instalado, baixe em: https://insomnia.rest/download

---

### **Passo 2: Importar o Arquivo**

#### **Método 1: Importar pelo Menu**
1. Clique em **Application** → **Preferences** → **Data**
2. Clique em **Import Data** → **From File**
3. Selecione o arquivo: `insomnia-collection.json`
4. Clique em **Import**

#### **Método 2: Arrastar e Soltar**
1. Abra a pasta do projeto
2. Arraste o arquivo `insomnia-collection.json` para a janela do Insomnia
3. Confirme a importação

---

## 🌍 Ambientes Disponíveis

Após importar, você terá **3 ambientes** configurados:

### **1. LOCAL (MongoDB Docker)** 🐳
```
Base URL: http://localhost:3001
Banco: MongoDB Local (Docker)
```

### **2. ATLAS (MongoDB Cloud)** ☁️
```
Base URL: http://localhost:3002
Banco: MongoDB Atlas (Cloud)
```

### **3. PRODUCTION (Render)** 🚀
```
Base URL: https://seu-app-producao.onrender.com
Banco: MongoDB Atlas (Cloud)
```

---

## 🔧 Como Usar

### **Passo 1: Selecionar o Ambiente**
1. No canto superior esquerdo, clique no dropdown de ambientes
2. Selecione o ambiente desejado:
   - **LOCAL** para testar com MongoDB Docker
   - **ATLAS** para testar com MongoDB Cloud
   - **PRODUCTION** após fazer deploy

---

### **Passo 2: Testar a API**

#### **1. Health Check**
- Abra: `01 - Health Check` → `Health Check`
- Clique em **Send**
- Você deve ver: `"database": { "status": "connected" }`

#### **2. Cadastrar Usuário**
- Abra: `02 - Register` → `Register - Success`
- Clique em **Send**
- **IMPORTANTE:** Copie o `token` retornado!

#### **3. Fazer Login**
- Abra: `03 - Login` → `Login - Success`
- Clique em **Send**
- **IMPORTANTE:** Copie o `token` retornado!

#### **4. Configurar o Token**
1. Clique no ambiente ativo (canto superior esquerdo)
2. Clique em **Manage Environments**
3. No ambiente selecionado, cole o token no campo `"token": ""`
4. Exemplo:
```json
{
  "base_url": "http://localhost:3001",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```
5. Clique em **Done**

#### **5. Testar Rota Protegida**
- Abra: `04 - Protected Route` → `Protected - Valid Token`
- Clique em **Send**
- Você deve ver: `"message": "Access granted"`

---

## 📋 Lista de Requests Disponíveis

### **01 - Health Check**
- ✅ Health Check

### **02 - Register (Cadastro)**
- ✅ Register - Success
- ❌ Register - Duplicate Email
- ❌ Register - Invalid Password
- ❌ Register - Invalid Email
- ❌ Register - Malformed JSON

### **03 - Login**
- ✅ Login - Success
- ❌ Login - Invalid Password
- ❌ Login - User Not Found
- ❌ Login - Invalid Email Format
- ❌ Login - Malformed JSON

### **04 - Protected Route**
- ✅ Protected - Valid Token
- ❌ Protected - No Token
- ❌ Protected - Invalid Token

---

## 🎬 Fluxo Completo de Teste

### **Cenário 1: Cadastro e Login (Sucesso)**
1. **Health Check** → Verificar API
2. **Register - Success** → Cadastrar usuário
3. Copiar o `token` retornado
4. Configurar o `token` no ambiente
5. **Protected - Valid Token** → Acessar rota protegida

### **Cenário 2: Login Existente**
1. **Login - Success** → Fazer login
2. Copiar o `token` retornado
3. Configurar o `token` no ambiente
4. **Protected - Valid Token** → Acessar rota protegida

### **Cenário 3: Testar Erros**
1. **Register - Duplicate Email** → Email já existe (422)
2. **Register - Invalid Password** → Senha curta (422)
3. **Login - Invalid Password** → Senha errada (401)
4. **Login - User Not Found** → Usuário inexistente (404)
5. **Protected - No Token** → Sem autenticação (401)
6. **Protected - Invalid Token** → Token inválido (401)

---

## 🔄 Alternando Entre Ambientes

### **Testar LOCAL e ATLAS ao mesmo tempo:**

1. **Abra duas abas no Insomnia** (Ctrl+T ou Cmd+T)
2. Na **Aba 1**: Selecione ambiente **LOCAL**
3. Na **Aba 2**: Selecione ambiente **ATLAS**
4. Teste os requests em paralelo

### **Verificar diferença entre bancos:**
- **LOCAL**: Usuários cadastrados no Docker
- **ATLAS**: Usuários cadastrados na nuvem
- São bancos **diferentes e independentes**!

---

## 📊 Códigos de Status HTTP

| Código | Significado | Exemplos |
|--------|-------------|----------|
| **200** | Sucesso | Login, Protected Route |
| **201** | Criado | Register |
| **400** | Bad Request | JSON malformado |
| **401** | Não autorizado | Token inválido, senha errada |
| **404** | Não encontrado | Usuário não existe |
| **422** | Validação | Email/senha inválidos |
| **500** | Erro do servidor | Erro interno |

---

## 🎥 Para o Vídeo de Demonstração

### **Estrutura Sugerida (máx 2 min):**

**00:00-00:15** - Mostrar Insomnia com coleção importada
**00:15-00:30** - Health Check nos 2 ambientes (LOCAL + ATLAS)
**00:30-00:45** - Register no LOCAL → Mostrar no Mongo Express
**00:45-01:00** - Register no ATLAS → Mostrar no MongoDB Atlas
**01:00-01:15** - Login e copiar token
**01:15-01:30** - Testar rota protegida com token válido
**01:30-01:45** - Testar erro (sem token ou token inválido)
**01:45-02:00** - Mostrar ambiente PRODUCTION (após deploy)

---

## 🆘 Troubleshooting

### **"Connection refused" ou "Failed to connect"**
- ✅ Verifique se os containers estão rodando: `docker ps`
- ✅ Execute: `./start-both.sh`

### **"Token inválido" ou "No token provided"**
- ✅ Certifique-se de configurar o token no ambiente
- ✅ O token expira em 24h, faça login novamente

### **"User already exists"**
- ✅ Normal! Use um email diferente ou o request de Login

### **Porta 3001 ou 3002 não responde**
- ✅ Aguarde 5-10 segundos após iniciar os containers
- ✅ Verifique logs: `docker logs jwt-auth-app-local`

---

## 📚 Recursos Adicionais

- **Documentação da API**: `API_DOCS.md`
- **Guia de Deploy**: `DEPLOY_GUIDE.md`
- **MongoDB Atlas**: `MONGODB_ATLAS_VISUAL_GUIDE.md`
- **Referência Rápida**: `QUICK_REFERENCE.md`

---

## ✅ Checklist de Importação

- [ ] Insomnia instalado
- [ ] Arquivo `insomnia-collection.json` importado
- [ ] 3 ambientes visíveis (LOCAL, ATLAS, PRODUCTION)
- [ ] Containers rodando (`./start-both.sh`)
- [ ] Health Check funcionando nos 2 ambientes
- [ ] Register testado com sucesso
- [ ] Login testado com sucesso
- [ ] Token configurado no ambiente
- [ ] Rota protegida acessada com sucesso

---

**Pronto! Agora você tem todos os requests organizados e prontos para testar! 🚀**
