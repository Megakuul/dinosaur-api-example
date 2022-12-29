FROM node:14

WORKDIR /usr/src/app

#Define Enviroment variables
#ENV PORT 8080

COPY package*.json ./
COPY prisma ./prisma/

RUN npm install --only=production

COPY . .

CMD npm start