#!/bin/sh
echo "🔍 Testando conexão HTTPS com web.local..."
if curl -s --cacert /usr/local/share/ca-certificates/raiz.crt.pem https://web.local > /tmp/output.txt; then
  echo "✅ Conexão segura estabelecida com sucesso!"
  cat /tmp/output.txt
else
  echo "❌ Falha na verificação da cadeia de confiança."
fi
