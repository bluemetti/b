# 📝 MongoDB Atlas - Guia Passo a Passo VISUAL

## 🎯 PASSO 1: CRIAR CONTA

### 1.1 Acessar o Site
```
https://www.mongodb.com/cloud/atlas/register
```

### 1.2 Criar Conta
**OPÇÃO A - Conta Google (Mais Rápido):**
- Clique no botão "Sign up with Google"
- Escolha sua conta Google
- Pule para o Passo 2

**OPÇÃO B - Email/Senha:**
- Preencha:
  - First Name: [seu nome]
  - Last Name: [seu sobrenome]
  - Email: [seu email]
  - Password: [crie uma senha forte]
- Marque "I agree to the Terms of Service and Privacy Policy"
- Clique em "Create your Atlas account"
- Verifique seu email e confirme a conta

---

## 🎯 PASSO 2: CRIAR PROJETO (se necessário)

Quando você fizer login pela primeira vez, o MongoDB Atlas pode criar um projeto automaticamente ou pedir para criar um.

### 2.1 Se pedir para criar projeto:
- Project Name: `JWT-Auth-Project` (ou qualquer nome)
- Clique em "Next"
- Clique em "Create Project"

---

## 🎯 PASSO 3: CRIAR CLUSTER (Banco de Dados)

### 3.1 Você verá uma tela "Deploy a cloud database"
- Clique no botão verde **"Create"** na opção **FREE** (M0)
- ⚠️ NÃO escolha as opções pagas!

### 3.2 Configurar Cluster
**Provider & Region:**
- Provider: deixe **AWS** (ou escolha Google Cloud/Azure se preferir)
- Region: escolha uma próxima ao Brasil:
  - **São Paulo (sa-east-1)** - Melhor opção!
  - OU Virginia (us-east-1)
  - OU qualquer outra disponível no FREE tier

**Cluster Name:**
- Nome: deixe `Cluster0` ou mude para `JWTAuthCluster`

**Cluster Tier:**
- ✅ Certifique-se que está selecionado **M0 Sandbox** (FREE)

### 3.3 Criar Cluster
- Clique no botão verde **"Create Cluster"**
- ⏳ Aguarde 3-5 minutos (o cluster está sendo criado)

---

## 🎯 PASSO 4: CONFIGURAR SEGURANÇA

Enquanto o cluster está sendo criado, uma tela de segurança aparecerá automaticamente.

### 4.1 Criar Usuário do Banco de Dados

**Você verá "Security Quickstart" com opção de criar usuário:**

```
Username: [escolha um, ex: admin ou seu_nome]
Password: [MongoDB gera uma automática, mas você pode criar sua própria]
```

**⚠️ IMPORTANTE:**
- ✅ Anote o **username** e **password** em um lugar seguro!
- Você vai precisar deles na connection string

**Exemplo:**
```
Username: admin
Password: MinhaSenh@Forte123
```

- Clique em **"Create User"** ou **"Create Database User"**

### 4.2 Configurar Network Access (IP Whitelist)

**Na mesma tela ou próxima aba:**

**Opção "Where would you like to connect from?"**
- Clique em **"Add My Current IP Address"** (vai adicionar seu IP atual)
- OU clique em **"Add a Different IP Address"**

**⚠️ IMPORTANTE - Para ambiente de testes/desenvolvimento:**
- Adicione: `0.0.0.0/0`
- Isso permite conexões de qualquer IP (necessário para o Render/Vercel)

**Como fazer:**
1. Se a opção aparecer, clique em "Allow Access from Anywhere"
2. OU clique em "Add IP Address"
3. Digite: `0.0.0.0/0`
4. Description: `Allow all`
5. Clique em "Add Entry" ou "Confirm"

---

## 🎯 PASSO 5: OBTER CONNECTION STRING

### 5.1 Ir para o Cluster
- Aguarde até o cluster estar pronto (status: "Active" com ✅)
- Na lista de clusters, você verá `Cluster0` (ou o nome que escolheu)

### 5.2 Clicar em "Connect"
- Clique no botão **"Connect"** do seu cluster
- Uma janela popup vai abrir

### 5.3 Escolher Método de Conexão
Na janela popup, você verá 3 opções:
1. "Compass" (GUI)
2. **"Drivers"** ← ESCOLHA ESTA!
3. "MongoDB Shell"

**Clique em "Drivers"**

### 5.4 Selecionar Driver
- **Driver**: Node.js
- **Version**: 6.8 or later (ou mais recente)

### 5.5 Copiar Connection String

Você verá algo parecido com:

```
mongodb+srv://admin:<password>@cluster0.xxxxx.mongodb.net/?retryWrites=true&w=majority
```

**⚠️ IMPORTANTE - Modificar a Connection String:**

**PASSO A:** Substitua `<password>` pela senha real que você criou no Passo 4.1

**ANTES:**
```
mongodb+srv://admin:<password>@cluster0.xxxxx.mongodb.net/?retryWrites=true&w=majority
```

**DEPOIS (exemplo):**
```
mongodb+srv://admin:MinhaSenh@Forte123@cluster0.xxxxx.mongodb.net/?retryWrites=true&w=majority
```

**⚠️ ATENÇÃO:** Se sua senha tem caracteres especiais (@, #, %, etc), você precisa codificá-los:
- `@` → `%40`
- `#` → `%23`
- `%` → `%25`
- `&` → `%26`

**PASSO B:** Adicionar o nome do banco de dados

**ANTES:**
```
mongodb+srv://admin:MinhaSenh@Forte123@cluster0.xxxxx.mongodb.net/?retryWrites=true&w=majority
```

**DEPOIS (adicione /jwt-auth-db antes do ?):**
```
mongodb+srv://admin:MinhaSenh@Forte123@cluster0.xxxxx.mongodb.net/jwt-auth-db?retryWrites=true&w=majority
```

### 5.6 Copiar Connection String Final
- Copie toda a string modificada
- Cole em um bloco de notas temporário

**Exemplo da string final correta:**
```
mongodb+srv://admin:MinhaSenh@Forte123@cluster0.ab1cd.mongodb.net/jwt-auth-db?retryWrites=true&w=majority
```

---

## 🎯 PASSO 6: TESTAR CONEXÃO

### Agora volte ao terminal e execute:

```bash
cd /workspaces/b/a

# Substitua pela sua connection string real
./test-mongodb-atlas.sh "mongodb+srv://admin:SUA_SENHA@cluster0.xxxxx.mongodb.net/jwt-auth-db?retryWrites=true&w=majority"
```

---

## ✅ CHECKLIST - VOCÊ TERMINOU QUANDO:

- [ ] Conta criada no MongoDB Atlas
- [ ] Projeto criado (ou usou o padrão)
- [ ] Cluster M0 (FREE) criado e status "Active"
- [ ] Usuário do banco criado (username + password anotados)
- [ ] IP 0.0.0.0/0 adicionado na whitelist
- [ ] Connection string copiada
- [ ] Connection string modificada (senha + nome do banco)
- [ ] Teste de conexão executado com sucesso

---

## 🆘 PROBLEMAS COMUNS

### "Authentication failed"
- ✅ Verifique se a senha na connection string está correta
- ✅ Verifique se codificou caracteres especiais (@ → %40)

### "Could not connect to any servers"
- ✅ Verifique se adicionou 0.0.0.0/0 na whitelist
- ✅ Aguarde alguns minutos (cluster pode estar iniciando)

### "Database name missing"
- ✅ Certifique-se de ter `/jwt-auth-db` antes do `?` na connection string

---

## 📸 QUANDO TERMINAR, ME ENVIE:

1. ✅ Screenshot do seu cluster "Active" no Atlas
2. ✅ Sua connection string (pode ocultar a senha se quiser)
3. ✅ Resultado do teste de conexão

---

**Está na tela de criação de conta? Me avise que te ajudo com o próximo passo! 🚀**
