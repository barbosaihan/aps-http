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

# 6. Instalar as dependências do servidor Node.js
RUN cd /app/aps-mcp-server && npm install

# 7. NOVO PASSO: Compilar o código do servidor
RUN cd /app/aps-mcp-server && npm run build

# 8. Expor a porta que o proxy vai usar
EXPOSE 8080

# 9. Comando para iniciar o proxy
CMD ["mcp-proxy", "node", "/app/aps-mcp-server/build/server.js"]