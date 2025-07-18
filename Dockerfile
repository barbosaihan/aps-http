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
    echo "APS_SA_PRIVATE_KEY=------BEGIN RSA PRIVATE KEY-----\nMIIEpAIBAAKCAQEAnHW0W8/NbuSwogIZA2qWjhhYsdhGTkKSsfVT9HxyZW7Sswn4OVmTuJ15HHZldryQ4F8WLEKGzqJoxrKvkZSOElJ8gbTUU64Vgli6EjsA/y0nsU6zl1PTIkONBpE17OY+EAiqcW680h3VY2eIUBscuqCVI7lN5NZUclytYyp6RFRZ65PhPv8uHkbodwEeH9aO448v56ZFeLJdhQJO3FwG5Ajfgqn54QwePFynBQBzHiZ2BRbjWg+u38vJgSMOsJSMY4L+1rxIie+QPJEhzqbMhIF+XjTEHSfLBZzUP5AL+O+F35xRtwFJvvwIcMj2NgbBDB0vPHIFvFKohcA/GG6N1QIDAQABAoIBAEMgCJofRD7gZJuNFNgvYZpi/aKHbFplG3S4ESXiQl4cNs9TZqiMMuFQxkYc0Zkoe2uXv/aLMDT03sjonoRx3KYlt38aasHf/SBoGqR5pgrUf6QFZO12rC2WF6oKoL0bZuMQJLf3z5DB9evo3kWn7CJxhKrH9JBKF/7cnhLehYhMj6Np5LvqlCwWBt19bhAI32BBH/3xPyNqXNlf5W34sQOyVfR48KcpKc4nLWdaWEXolKEUmw3WJYgmn5VBZD7cUuKLobGPsSpwHyza/oUGRSTXbNJU0R7kCKVb/IMZ2664Q4rPucy6HjM2px9ES6+jjluU+lKxtUBPiO+OOxI6Gr0CgYEA3HYikZCWFG9y6vj9v/tTJN4KIpBGmu4O3F/3QLwpgs7v4egZp3i3HSrr4m82kDb7tqB69eGkhFXvAGvbe6b/f/+oMhbSeC+gqrM8uL+ExRob8+uxuDiyx5IAym7U2I4XT3RagzSrQD+Js9mhMa/s/1wE13xv7v6bJhwJcTEKGLMCgYEAta5jbNGEDxHb/BOHmdtbVL4R2MBU8KIriXyykTonb34uos2f3y0WtZhwDXuGBcEAPdD/7wOhHjCPn+c1n8zSFIyVvNUraE1CJPFLyOMYSQhxIAz6c7Lz66qPdzx3Ek6XxC4iTry3heJ/yxvIBZsKGv7nPcuSLEhr5pxO2VXZs1cCgYEAtQlJn9FkfMl8S9pFvbYrc5XmKrXhVO5yQ6OGjaE2UVWPhSosjurBK/GIHLyIyOptz21/K5SsnYNXrTfk12iuXTTasK8vDETIIgTnsyqKY7TqCWad3RKqNNn/TjyvClm8aKG6hg3lJvBGKutmxD+cVaIB09Y6sL5hN21Ej6/eg6MCgYAYe+fqQlIJtd5vmjIsCePFB9hf3YuU4kX7wVJPQAcQf3DJf+yLpwfocSKornzhSaE+s2vKSjLsXp78baxMXM3y9v8284NmCwNe9yW/bNtY/EpCh305GmTE3bd32i4xyWWqio0VD1msMVoHhTbvinVSLgf7y/NnBFuGOIpnv6oXAQKBgQDYjcrP3Z2iRuMXglH3mpxt5KTce8kIBX1NqAITb2djjtG/llc4obswf/uWQOPHZcSxLzMRR+ZmgaOD1oEmovy7jlceIQeBECkmdv1hBpsJnNrsPb35CrV8w2XmQXvLh6fqM3/vl150B/bS6w9A3EYc+p4wCu3+svzRpJpbuW633w==\n-----END RSA PRIVATE KEY-----\n" >> /app/aps-mcp-server/.env

# 10. Expor a porta que o proxy vai usar
EXPOSE 8080

# 11. Comando final para iniciar a aplicação
CMD ["mcp-proxy", "--host", "0.0.0.0", "--port", "8080", "node", "/app/aps-mcp-server/build/server.js"]
