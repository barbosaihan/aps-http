FROM python:3.10-slim-buster

WORKDIR /app

RUN pip install mcp-proxy

COPY ./aps-mcp-server /aps-mcp-server

EXPOSE 8080

CMD ["mcp-proxy", "--port=8080", "--", "node", "/aps-mcp-server/build/server.js"]
