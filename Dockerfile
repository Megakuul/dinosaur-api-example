FROM node:14

WORKDIR /usr/src/app

#Define Enviroment variables
#ENV PORT 8080

COPY package*.json ./
COPY prisma ./prisma/

RUN npm install --only=production

RUN npm install -g prisma-client-lib

RUN npm install

COPY . .

CMD npx prisma migrate deploy

CMD npm start