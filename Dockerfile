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

# A linha que copiava 'private_key.pem' foi REMOVIDA por ser desnecessária.

# 6. Instalar as dependências do servidor Node.js
RUN cd /app/aps-mcp-server && npm install

# 7. Compilar o código do servidor
RUN cd /app/aps-mcp-server && npm run build

# 8. Criar o arquivo .env com as credenciais e a chave PKCS#8
# A chave privada agora está entre aspas simples para garantir que seja lida corretamente.
RUN echo "APS_CLIENT_ID=fJSqoo0fTrXvMVPCMp8ZkpQXNICdoxqHYAgATZEVpiduaiyo" > /app/aps-mcp-server/.env && \
    echo "APS_CLIENT_SECRET=HdKJ5S9X22rtMrdmsPYOnYQwY6WJiq2a2HsQCbHsmFAfiU1X8w9C6mHGEO0egfS9" >> /app/aps-mcp-server/.env && \
    echo "APS_SA_ID=2SN2J9GFLBSS6RN3" >> /app/aps-mcp-server/.env && \
    echo "APS_SA_EMAIL=ssa-ihanbb@fJSqoo0fTrXvMVPCMp8ZkpQXNICdoxqHYAgATZEVpiduaiyo.adskserviceaccount.com" >> /app/saps-mcp-server/.env && \
    echo "APS_SA_KEY_ID=4f7741c0-dcf5-443f-a074-eb272068aa4a" >> /app/aps-mcp-server/.env && \
    echo 'APS_SA_PRIVATE_KEY=-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCcdbRbz81u5LCi\nAhkDapaOGFix2EZOQpKx9VP0fHJlbtKzCfg5WZO4nXkcdmV2vJDgXxYsQobOomjG\nsq+RlI4SUnyBtNRTrhWCWLoSOwD/LSexTrOXU9MiQ40GkTXs5j4QCKpxbrzSHdVj\nZ4hQGxy6oJUjuU3k1lRyXK1jKnpEVFnrk+E+/y4eRuh3AR4f1o7jjy/npkV4sl2F\nAk7cXAbkCN+CqfnhDB48XKcFAHMeJnYFFuNaD67fy8mBIw6wlIxjgv7WvEiJ75A8\nkSHOpsyEgX5eNMQdJ8sFnNQ/kAv474X35xRtwFJvvwIcMj2NgbBDB0vPHIFvFKoh\nwD8Ybo3VAgMBAAECggEAQyAImh9EPuBkm40U2G9hmmL9oodsWmUbdLgRJeJCXhw2\nz1NmqIwy4VDGRhzRmSh7a5e/9oswNPTeyOiehHHcpiW3fxpqwd/9IGgapHmmCtR/\npAVk7XasLZYXqgqgvRtm4xAkt/fPkMH16+jeRafsInGEqsf0kEoX/tyeEt6FiEyP\no2nku+qULBYG3X1uEAjfYEEf/3xPyNqXNlf5W34sQOyVfR48KcpKc4nLWdaWEXol\noRSbDdYliCaflUFkPtxS4ouhsY+xKnAfLNr+hQZJFNds0lTRHuQIpVv8gxnbrrhD\nis+5zLoeMzanH0RLr6OOW5T6UrG1QE+I7447EjoavQKBgQDcdiKRkJYUb3Lq+P2/\n+1Mk3goikEaa7g7cX/dAvCmCzu/h6BmneLcdKuvibzaQNvu2oHr14aSEVe8Aa9t7\npv9//6gyFtJ4L6Cqszy4v4TFGhvz67G4OLLHkgDKbtTYjhdPdFqDNKtAP4mz2aEx\nr+z/XATXfG/u/psmHAlxMQoYswKBgQC1rmNs0YQPEdv8E4eZ21tUvhHYwFTwoiuJ\nfLKROidvfi6izZ/fLRa1mHANe4YFwQA90P/vA6EeMI+f5zWfzNIUjJW81StoTUIk\n8UvI4xhJCHEgDPpzsvPrqo93PHcSTpfELiJOvLeF4n/LG8gFmwoa/uc9y5IsSGvm\nnE7ZVdmzVwKBgQC1CUmf0WR8yXxL2kW9titzleYqteFU7nJDo4aNoTZRVY+FKiyO\n6sEr8YgcvIjI6m3PbX8rlKydg1etN+TXaK5dNNqwry8MRMgiBOezKopjtOoJZp3d\nEqo02f9OPK8KWbxoobqGDeUm8EYq62bEP5xVogHT1jqwvmE3bUSPr96DowKBgBh7\n5+pCUgm13m+aMiwJ48UH2F/di5TiRfvBUk9ABxB/cMl/7IunB+hxIqiufOFJoT6z\na8pKMuxenvxtrExczfL2/zbzg2YLA173Jb9s21j8SkKHfTkaZMTdt32i4xyWWqK\njRUPWawxWgeFNu+KdVIuB/vL9cEW4Y4ime/qhcBAoGBANiNys/dnaJG4xeCUfrea\nnG3kpNx7yQgFfU2oAhNvZ2OO0b+WVzihuzB/+5ZA48dlxLEvMxFH5ZmgaOD1oEmovy7jlceIQeBECkmdv1hBpsJnNrsPb35CrV8\nw2XmQXvLh6fqM3/vl150B/bS6w9A3EYc+p4wCu3+svzRpJpbuW633w==\n-----END PRIVATE KEY-----' >> /app/aps-mcp-server/.env

# 9. Expor a porta que o proxy vai usar
EXPOSE 8080

# 10. Comando final para iniciar a aplicação
CMD ["mcp-proxy", "--host", "0.0.0.0", "--port", "8080", "node", "/app/aps-mcp-server/build/server.js"]
