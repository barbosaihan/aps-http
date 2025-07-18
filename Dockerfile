# 1. Usar a imagem base do Python
FROM python:3.10-slim-buster

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

# (Opcional, mas recomendado) Instalar as dependências do servidor Node.js
RUN cd /app/aps-mcp-server && npm install

# 6. Expor a porta que o proxy vai usar
EXPOSE 8080

# 7. Comando para iniciar o proxy
# O proxy, por sua vez, vai iniciar o 'node'
CMD ["mcp-proxy", "node", "/app/aps-mcp-server/build/server.js"]