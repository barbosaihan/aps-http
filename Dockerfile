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

# 9. Expor a porta que o proxy vai usar
EXPOSE 8080

# 10. Comando para iniciar o proxy (Temporariamente desativado)
# CMD ["mcp-proxy", "node", "/app/aps-mcp-server/build/server.js"]

# --- NOVO COMANDO PARA DEBUG ---
# Este comando vai listar os arquivos, imprimir as variáveis de ambiente,
# mostrar o conteúdo do .env e manter o contêiner rodando por 1 hora.
CMD ["sh", "-c", "echo '--- LISTANDO ARQUIVOS em /app ---'; ls -la /app; echo '\n--- VARIAVEIS DE AMBIENTE (printenv) ---'; printenv; echo '\n--- CONTEUDO DO ARQUIVO .env ---'; cat /app/.env || echo 'Arquivo .env nao foi encontrado.'; echo '\n--- FIM DO DEBUG, AGUARDANDO ---'; sleep 3600"]