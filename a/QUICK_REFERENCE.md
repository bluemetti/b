# 🚀 COLA RÁPIDA - MongoDB Atlas

## 📋 INFORMAÇÕES QUE VOCÊ PRECISA ANOTAR:

### Durante a criação do MongoDB Atlas:

**1. Usuário do Banco:**
```
Username: _______________
Password: _______________
```

**2. Connection String Original:**
```
mongodb+srv://admin:<password>@cluster0.xxxxx.mongodb.net/?retryWrites=true&w=majority
```

**3. Connection String Modificada (USAR ESTA):**
```
mongodb+srv://admin:SUA_SENHA@cluster0.xxxxx.mongodb.net/jwt-auth-db?retryWrites=true&w=majority
```

---

## ⚡ COMANDOS RÁPIDOS APÓS CONFIGURAR:

### Testar conexão:
```bash
cd /workspaces/b/a
./test-mongodb-atlas.sh "sua_connection_string_aqui"
```

### Se o teste passar, cadastrar um usuário:
```bash
curl -X POST http://localhost:3001/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Usuario Atlas",
    "email": "atlas@email.com",
    "password": "Senha@123"
  }' | jq .
```

### Ver usuários no MongoDB Atlas:
1. Acesse: https://cloud.mongodb.com
2. Login
3. Clique em "Browse Collections"
4. Selecione `jwt-auth-db` → `users`
5. Você verá os usuários cadastrados!

---

## 🎯 PRÓXIMOS PASSOS DEPOIS DO ATLAS:

1. ✅ MongoDB Atlas funcionando
2. ⏳ Push código para GitHub
3. ⏳ Deploy no Render
4. ⏳ Gravar vídeo
5. ⏳ Submeter trabalho

---

## 📞 STATUS ATUAL:

**Onde você deve estar agora:**
- [ ] Criando conta no MongoDB Atlas
- [ ] Configurando cluster
- [ ] Obtendo connection string

**Me avise quando chegar em cada etapa!** 🚀
