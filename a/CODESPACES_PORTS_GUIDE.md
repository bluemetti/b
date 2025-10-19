# 🌐 GUIA: Configurar Portas no GitHub Codespaces para Insomnia

## ❓ Por que você está vendo "Couldn't connect to server"?

Você está rodando a aplicação no **GitHub Codespaces** (servidor remoto na nuvem), mas tentando acessar `localhost` do **seu computador local** onde o Insomnia está instalado.

**Solução:** Usar as URLs públicas do Codespaces!

---

## 🔧 Passo a Passo: Tornar Portas Públicas

### **1. Abrir o Painel de Portas no VS Code**

1. No VS Code (dentro do Codespace), procure a aba **"PORTS"** na parte inferior
2. Ou use o atalho: `Ctrl+Shift+P` (Windows/Linux) ou `Cmd+Shift+P` (Mac)
3. Digite: `Ports: Focus on Ports View`
4. Pressione Enter

---

### **2. Verificar Portas em Uso**

Você deve ver algo assim:

```
PORT    | VISIBILITY    | FORWARDED ADDRESS
--------|---------------|------------------------------------------
3001    | Private       | organic-space-meme-7v9xrv7jjvp9cxpj9-3001...
3002    | Private       | organic-space-meme-7v9xrv7jjvp9cxpj9-3002...
8081    | Private       | organic-space-meme-7v9xrv7jjvp9cxpj9-8081...
27017   | Private       | organic-space-meme-7v9xrv7jjvp9cxpj9-27017...
```

---

### **3. Tornar Portas Públicas**

Para cada porta (3001, 3002, 8081):

1. **Clique com botão direito** na porta
2. Selecione **"Port Visibility"**
3. Escolha **"Public"**

Ou:

1. **Clique com botão direito** na porta
2. Selecione **"Change Port Visibility"**
3. Escolha **"Public"**

---

### **4. Resultado Esperado**

Após tornar públicas:

```
PORT    | VISIBILITY    | FORWARDED ADDRESS
--------|---------------|------------------------------------------
3001    | Public ✅     | organic-space-meme-7v9xrv7jjvp9cxpj9-3001...
3002    | Public ✅     | organic-space-meme-7v9xrv7jjvp9cxpj9-3002...
8081    | Public ✅     | organic-space-meme-7v9xrv7jjvp9cxpj9-8081...
```

---

## 🌐 URLs para Usar no Insomnia

Depois de tornar as portas públicas, use estas URLs:

### **🐳 API LOCAL (MongoDB Docker)**
```
https://organic-space-meme-7v9xrv7jjvp9cxpj9-3001.app.github.dev
```

### **☁️ API ATLAS (MongoDB Cloud)**
```
https://organic-space-meme-7v9xrv7jjvp9cxpj9-3002.app.github.dev
```

### **📦 Mongo Express (Interface Web)**
```
https://organic-space-meme-7v9xrv7jjvp9cxpj9-8081.app.github.dev
```

---

## ✅ Testar no Terminal (dentro do Codespace)

Execute estes comandos **dentro do Codespace** para confirmar que está funcionando:

```bash
# Testar LOCAL
curl https://organic-space-meme-7v9xrv7jjvp9cxpj9-3001.app.github.dev/health

# Testar ATLAS
curl https://organic-space-meme-7v9xrv7jjvp9cxpj9-3002.app.github.dev/health
```

Ambos devem retornar JSON com `"success": true`

---

## 🔄 Importar no Insomnia

1. **Reimporte** o arquivo atualizado:
   ```
   insomnia-collection.json
   ```

2. As URLs já estão configuradas automaticamente!

3. **Selecione o ambiente:**
   - `LOCAL (MongoDB Docker)` para porta 3001
   - `ATLAS (MongoDB Cloud)` para porta 3002

4. **Teste:**
   - Health Check
   - Register
   - Login
   - Protected Route

---

## ⚠️ Troubleshooting

### **Problema: "Couldn't connect to server"**

✅ **Solução:**
1. Verifique se as portas estão **Public** no painel Ports
2. Certifique-se de usar `https://` (não `http://`)
3. Use as URLs do Codespaces (não `localhost`)

### **Problema: "404 Not Found"**

✅ **Solução:**
- Normal para rota `/`
- Teste `/health` ao invés

### **Problema: Container não está rodando**

✅ **Solução:**
```bash
# Verificar containers
docker ps

# Se não aparecer jwt-auth-app-local ou jwt-auth-app-atlas:
./start-both.sh
```

---

## 🎯 Resumo Rápido

1. ✅ **Abrir painel PORTS** no VS Code
2. ✅ **Tornar portas 3001 e 3002 públicas** (botão direito → Public)
3. ✅ **Importar** `insomnia-collection.json` no Insomnia
4. ✅ **Testar** endpoints (selecione ambiente LOCAL ou ATLAS)

---

## 📊 Exemplo de Request no Insomnia

### **Health Check**
```
GET https://organic-space-meme-7v9xrv7jjvp9cxpj9-3002.app.github.dev/health
```

**Resposta esperada:**
```json
{
  "success": true,
  "message": "Server is running!",
  "environment": "production",
  "database": {
    "status": "connected",
    "name": "jwt-auth-db"
  }
}
```

### **Register**
```
POST https://organic-space-meme-7v9xrv7jjvp9cxpj9-3002.app.github.dev/register
Content-Type: application/json

{
  "name": "João Silva",
  "email": "joao@email.com",
  "password": "Senha@123"
}
```

---

## 🎉 Pronto!

Agora você pode testar a API no Insomnia usando as URLs públicas do GitHub Codespaces! 🚀
