FROM node:14-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

WORKDIR /app
COPY . ./
RUN npm run build

FROM node:14-alpine

WORKDIR /app
COPY --from=0 /app/package*.json ./
RUN npm install --only=production
RUN npm cache clean --force
COPY --from=0 /app/dist ./dist

USER node
ENV PORT=8080
EXPOSE 8080

CMD ["node", "dist/main.js"]

