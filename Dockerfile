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

# 7. Compilar o código do servidor
RUN cd /app/aps-mcp-server && npm run build

# 8. Criar o arquivo .env com as credenciais e a chave PKCS#8 formatada
# Esta é a única abordagem que a aplicação 'aps-mcp-server' entende.
RUN echo "APS_CLIENT_ID=fJSqoo0fTrXvMVPCMp8ZkpQXNICdoxqHYAgATZEVpiduaiyo" > /app/aps-mcp-server/.env && \
    echo "APS_CLIENT_SECRET=HdKJ5S9X22rtMrdmsPYOnYQwY6WJiq2a2HsQCbHsmFAfiU1X8w9C6mHGEO0egfS9" >> /app/aps-mcp-server/.env && \
    echo "APS_SA_ID=2SN2J9GFLBSS6RN3" >> /app/aps-mcp-server/.env && \
    echo "APS_SA_EMAIL=ssa-ihanbb@fJSqoo0fTrXvMVPCMp8ZkpQXNICdoxqHYAgATZEVpiduaiyo.adskserviceaccount.com" >> /app/aps-mcp-server/.env && \
    echo "APS_SA_KEY_ID=4f7741c0-dcf5-443f-a074-eb272068aa4a" >> /app/aps-mcp-server/.env && \
    echo 'APS_SA_PRIVATE_KEY="-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAnHW0W8/NbuSwogIZA2qWjhhYsdhGTkKSsfVT9HxyZW7Sswn4
OVmTuJ15HHZldryQ4F8WLEKGzqJoxrKvkZSOElJ8gbTUU64Vgli6EjsA/y0nsU6z
l1PTIkONBpE17OY+EAiqcW680h3VY2eIUBscuqCVI7lN5NZUclytYyp6RFRZ65Ph
Pv8uHkbodwEeH9aO448v56ZFeLJdhQJO3FwG5Ajfgqn54QwePFynBQBzHiZ2BRbj
Wg+u38vJgSMOsJSMY4L+1rxIie+QPJEhzqbMhIF+XjTEHSfLBZzUP5AL+O+F35xR
twFJvvwIcMj2NgbBDB0vPHIFvFKohcA/GG6N1QIDAQABAoIBAEMgCJofRD7gZJuN
FNgvYZpi/aKHbFplG3S4ESXiQl4cNs9TZqiMMuFQxkYc0Zkoe2uXv/aLMDT03sjo
noRx3KYlt38aasHf/SBoGqR5pgrUf6QFZO12rC2WF6oKoL0bZuMQJLf3z5DB9evo
3kWn7CJxhKrH9JBKF/7cnhLehYhMj6Np5LvqlCwWBt19bhAI32BBH/3xPyNqXNlf
5W34sQOyVfR48KcpKc4nLWdaWEXolKEUmw3WJYgmn5VBZD7cUuKLobGPsSpwHyza
/oUGRSTXbNJU0R7kCKVb/IMZ2664Q4rPucy6HjM2px9ES6+jjluU+lKxtUBPiO+O
OxI6Gr0CgYEA3HYikZCWFG9y6vj9v/tTJN4KIpBGmu4O3F/3QLwpgs7v4egZp3i3
HSrr4m82kDb7tqB69eGkhFXvAGvbe6b/f/+oMhbSeC+gqrM8uL+ExRob8+uxuDiy
x5IAym7U2I4XT3RagzSrQD+Js9mhMa/s/1wE13xv7v6bJhwJcTEKGLMCgYEAta5j
bNGEDxHb/BOHmdtbVL4R2MBU8KIriXyykTonb34uos2f3y0WtZhwDXuGBcEAPdD/
7wOhHjCPn+c1n8zSFIyVvNUraE1CJPFLyOMYSQhxIAz6c7Lz66qPdzx3Ek6XxC4i
Try3heJ/yxvIBZsKGv7nPcuSLEhr5pxO2VXZs1cCgYEAtQlJn9FkfMl8S9pFvbYr
c5XmKrXhVO5yQ6OGjaE2UVWPhSosjurBK/GIHLyIyOptz21/K5SsnYNXrTfk12iu
XTTasK8vDETIIgTnsyqKY7TqCWad3RKqNNn/TjyvClm8aKG6hg3lJvBGKutmxD+c
VaIB09Y6sL5hN21Ej6/eg6MCgYAYe+fqQlIJtd5vmjIsCePFB9hf3YuU4kX7wVJP
QAcQf3DJf+yLpwfocSKornzhSaE+s2vKSjLsXp78baxMXM3y9v8284NmCwNe9yW/
bNtY/EpCh305GmTE3bd32i4xyWWqio0VD1msMVoHhTbvinVSLgf7y/NnBFuGOIpn
v6oXAQKBgQDYjcrP3Z2iRuMXglH3mpxt5KTce8kIBX1NqAITb2djjtG/llc4obsw
f/uWQOPHZcSxLzMRR+ZmgaOD1oEmovy7jlceIQeBECkmdv1hBpsJnNrsPb35CrV8
w2XmQXvLh6fqM3/vl150B/bS6w9A3EYc+p4wCu3+svzRpJpbuW633w==
-----END RSA PRIVATE KEY-----
"' >> /app/aps-mcp-server/.env

# 9. Expor a porta que o proxy vai usar
EXPOSE 8080

# 10. Comando final para iniciar a aplicação
CMD ["mcp-proxy", "--host", "0.0.0.0", "--port", "8080", "node", "/app/aps-mcp-server/build/server.js"]
