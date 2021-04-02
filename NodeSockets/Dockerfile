FROM node:alpine

WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install

COPY . .
EXPOSE 8081/tcp
EXPOSE 8081/tcp

CMD [ "node", "index.js" ]