# 🌐 CONFIGURAÇÃO DE PORTAS NO GITHUB CODESPACES

## ⚠️ PROBLEMA: "Couldn't connect to server" no Insomnia

Se você está rodando o projeto no **GitHub Codespaces** e o Insomnia (na sua máquina local) não consegue conectar, você precisa tornar as portas **públicas**.

---

## 🔧 SOLUÇÃO: Tornar Portas Públicas

### **Passo 1: Abrir o Painel de Portas**

1. No VS Code (Codespaces), pressione: **Ctrl + `** (abre o terminal)
2. Clique na aba **"PORTS"** (ao lado de "TERMINAL")

---

### **Passo 2: Tornar as Portas Públicas**

Você verá as portas:
- **3001** - API LOCAL
- **3002** - API ATLAS  
- **8081** - Mongo Express
- **27017** - MongoDB

**Para cada porta (3001, 3002, 8081):**

1. Clique com o **botão direito** na porta
2. Selecione **"Port Visibility"**
3. Escolha **"Public"**

**OU**

1. Clique com o **botão direito** na porta
2. Selecione **"Change Port Visibility..."**
3. Escolha **"Public"**

---

### **Passo 3: Verificar as URLs Públicas**

Depois de tornar as portas públicas, você verá as URLs na coluna **"Forwarded Address"**:

```
3001 - https://organic-space-meme-7v9xrv7jjvp9cxpj9-3001.app.github.dev
3002 - https://organic-space-meme-7v9xrv7jjvp9cxpj9-3002.app.github.dev
8081 - https://organic-space-meme-7v9xrv7jjvp9cxpj9-8081.app.github.dev
```

---

## 🎯 ALTERNATIVA: TESTAR DENTRO DO CODESPACES

Se você não quer/pode tornar as portas públicas, você pode:

### **Opção 1: Usar Insomnia no Navegador (Web)**
- Acesse: https://insomnia.rest/
- Faça login e use a versão web
- Dentro do navegador do Codespaces

### **Opção 2: Usar cURL no Terminal do Codespaces**
```bash
# Testar LOCAL
curl http://localhost:3001/health

# Testar ATLAS
curl http://localhost:3002/health

# Cadastrar usuário
curl -X POST http://localhost:3001/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "João Silva",
    "email": "joao.silva@email.com",
    "password": "Senha@123"
  }'
```

### **Opção 3: Criar arquivo de testes automatizado**
```bash
# Já temos o script pronto!
./test-all.sh
```

---

## 📋 RESUMO DAS URLs

### **Dentro do Codespaces (sempre funciona):**
```
LOCAL:  http://localhost:3001
ATLAS:  http://localhost:3002
Mongo:  http://localhost:8081
```

### **Fora do Codespaces (requer portas públicas):**
```
LOCAL:  https://organic-space-meme-7v9xrv7jjvp9cxpj9-3001.app.github.dev
ATLAS:  https://organic-space-meme-7v9xrv7jjvp9cxpj9-3002.app.github.dev
Mongo:  https://organic-space-meme-7v9xrv7jjvp9cxpj9-8081.app.github.dev
```

---

## ✅ TESTAR SE FUNCIONOU

### **No Terminal do Codespaces:**
```bash
# Testar LOCAL
curl http://localhost:3001/health | jq

# Testar ATLAS
curl http://localhost:3002/health | jq
```

### **No Insomnia (sua máquina):**
1. Importe `insomnia-collection.json`
2. Selecione o ambiente **"LOCAL"** ou **"ATLAS"**
3. Execute o request **"Health Check"**
4. Deve retornar: `{"success": true, "database": {...}}`

---

## 🎥 PARA O VÍDEO DE DEMONSTRAÇÃO

**Opção 1: Mostrar tudo no Codespaces**
- Abra o navegador no Codespaces
- Use as URLs `localhost:3001` e `localhost:3002`
- Mostre o Mongo Express em `localhost:8081`

**Opção 2: Mostrar no Insomnia local**
- Torne as portas públicas
- Use as URLs completas do GitHub
- Importe a coleção e teste

---

## 🆘 TROUBLESHOOTING

### **Erro: "Couldn't connect to server"**
- ✅ Verifique se os containers estão rodando: `docker ps`
- ✅ Torne as portas públicas no Codespaces
- ✅ Use `localhost` se estiver testando dentro do Codespaces

### **Erro: "Port is already in use"**
- ✅ Pare todos os containers: `./stop-all.sh`
- ✅ Reinicie: `./start-both.sh`

### **Porta 3001 não responde**
- ✅ Verifique logs: `docker logs jwt-auth-app-local`
- ✅ Aguarde 10 segundos após iniciar

---

## 💡 RECOMENDAÇÃO

**Para o seu trabalho, sugiro:**

1. **Gravar vídeo dentro do Codespaces** usando `localhost`
2. **Fazer deploy no Render** (URL pública permanente)
3. **Mostrar 3 ambientes no vídeo:**
   - LOCAL: `localhost:3001`
   - ATLAS: `localhost:3002`  
   - PRODUCTION: `https://seu-app.onrender.com`

Isso é mais simples e não depende de configurar portas públicas! 🚀
