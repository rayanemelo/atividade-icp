# Infraestrutura de Chaves Públicas (ICP) com TLS, AIA, CRL e Confiança Raiz


Este projeto demonstra a criação de uma **Infraestrutura de Chaves Públicas completa (ICP)** com:

- **CA Raiz e CA Intermediária** com certificados e CRLs próprias  
- **Publicação dos artefatos** via servidor HTTP (`pki.local`)  
- **Servidor HTTPS (`web.local`)** com certificado emitido pela CA Intermediária  
- **Cliente (`client`)** confiando apenas na CA Raiz, validando automaticamente via AIA/CDP  


## Passo a Passo

### Etapa 1 — Criar a CA Raiz
```bash
cd raiz

# Criar arquivos de controle
touch index.txt
echo 1000 > serial
echo 1000 > crlnumber

# Gerar a chave privada da CA Raiz
openssl genrsa -aes256 -out private/raiz.key.pem 4096
chmod 400 private/raiz.key.pem

# Gerar o certificado autoassinado da CA Raiz
openssl req -config openssl.cnf -key private/raiz.key.pem -new -x509 -days 730 -sha256 -extensions v3_ca -out certs/raiz.crt.pem

# Verificar o certificado gerado
openssl x509 -in certs/raiz.crt.pem -noout -text
```

### Etapa 2 — Criar a CA Intermediária

```bash
cd intermediaria

# Criar arquivos de controle
touch index.txt
echo 1000 > serial
echo 1000 > crlnumber
mkdir -p certs crl newcerts private csr

# Gerar a chave privada 
openssl genrsa -aes256 -out private/intermediaria.key.pem 4096
chmod 400 private/intermediaria.key.pem

# Criar assinatura de certificado (CSR)
openssl req -config openssl.cnf -new -sha256 -key private/intermediaria.key.pem -out csr/intermediaria.csr.pem

# Assinar o CSR usando a CA Raiz
cd raiz

openssl ca -config openssl.cnf -extensions v3_ca -days 365 -notext -md sha256 -in ../intermediaria/csr/intermediaria.csr.pem -out ../intermediaria/certs/intermediaria.crt.pem

# Gerar a CRL da intermediária
cd intermediaria

openssl ca -config openssl.cnf -gencrl -out crl/intermediaria.crl.pem

# Verificar o certificado
openssl x509 -in certs/intermediaria.crt.pem -noout -text
```

### Etapa 3 — Emitir o Certificado TLS do Servidor (`web.local`)

```bash
cd web-server

# Gerar a chave privada do servidor
openssl genrsa -out private/web.local.key.pem 2048
chmod 400 private/web.local.key.pem

# Criar o Certificate Signing Request (CSR)
openssl req -config openssl.cnf -key private/web.local.key.pem -new -sha256 -out csr/web.local.csr.pem

# Assinar o CSR com a CA Intermediária
cd ../intermediaria

openssl ca -config openssl.cnf -extensions v3_server -days 180 -notext -md sha256 -in ../web-server/csr/web.local.csr.pem -out ../web-server/certs/web.local.crt.pem

# Verificar o certificado TLS
openssl x509 -in ../web-server/certs/web.local.crt.pem -noout -text

# Testar a cadeia completa
cd ..

cat web-server/certs/web.local.crt.pem intermediaria/certs/intermediaria.crt.pem raiz/certs/raiz.crt.pem > fullchain.pem

# Verificar a cadeia:
openssl verify -CAfile raiz/certs/raiz.crt.pem -untrusted intermediaria/certs/intermediaria.crt.pem web-server/certs/web.local.crt.pem

# Saída esperada:
web-server/certs/web.local.crt.pem: OK
```

 
### Etapa 4 — Subir os Containers

```bash
docker compose up --build
```

### Etapa 5 — Testar a Confiança via AIA/CDP

```bash
curl --cacert raiz/certs/raiz.crt.pem https://web.local
```

**Saída esperada:**  
```
Servidor HTTPS ativo e certificado válido!
```
