FROM node:12.2.0-alpine
WORKDIR app
COPY package*.json ./
RUN npm install
RUN npm ci --only=production
COPY . .
EXPOSE 8000
CMD ["node","app.js"]
