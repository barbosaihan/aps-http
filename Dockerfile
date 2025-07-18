# 1. Usar uma imagem base MODERNA do Python (Debian 12)
FROM python:3.10-slim-bookworm

# 2. Instalar o Node.js e o npm
RUN apt-get update && \
    apt-get install -y nodejs npm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 3. Definir o diretório de trabalho
WORKDIR /app

# 4. Instalar o mcp-proxy via pip
RUN pip install mcp-proxy

# 5. Copiar o código do servidor para dentro da imagem
COPY ./aps-mcp-server /app/aps-mcp-server

# 6. Copiar o arquivo da chave privada para a imagem
COPY ./private_key.pem /app/private_key.pem

# 7. Instalar as dependências do servidor Node.js
RUN cd /app/aps-mcp-server && npm install

# 8. Compilar o código do servidor
RUN cd /app/aps-mcp-server && npm run build

# 9. ---- NOVO: CRIAR O ARQUIVO .ENV MANUALMENTE ----
# Substitua os valores 'SEU_..._AQUI' pelas suas credenciais reais.
RUN echo "APS_CLIENT_ID=fJSqoo0fTrXvMVPCMp8ZkpQXNICdoxqHYAgATZEVpiduaiyo" > /app/aps-mcp-server/.env && \
    echo "APS_CLIENT_SECRET=HdKJ5S9X22rtMrdmsPYOnYQwY6WJiq2a2HsQCbHsmFAfiU1X8w9C6mHGEO0egfS9" >> /app/aps-mcp-server/.env && \
    echo "APS_SA_ID=2SN2J9GFLBSS6RN3" >> /app/aps-mcp-server/.env && \
    echo "APS_SA_EMAIL=ssa-ihanbb@fJSqoo0fTrXvMVPCMp8ZkpQXNICdoxqHYAgATZEVpiduaiyo.adskserviceaccount.com" >> /app/aps-mcp-server/.env && \
    echo "APS_SA_KEY_ID=4f7741c0-dcf5-443f-a074-eb272068aa4a" >> /app/aps-mcp-server/.env && \
    echo "APS_SA_PRIVATE_KEY=/app/private_key.pem" >> /app/aps-mcp-server/.env

# 10. Expor a porta que o proxy vai usar
EXPOSE 8080

# 11. Comando final para iniciar a aplicação
CMD ["mcp-proxy", "--host", "0.0.0.0", "--port", "8080", "node", "/app/aps-mcp-server/build/server.js"]
