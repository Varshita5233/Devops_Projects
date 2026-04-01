FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

FROM node:18-alpine AS production

WORKDIR /app

COPY --from=builder /app/server.js .

EXPOSE 3000

CMD ["node", "server.js"]




