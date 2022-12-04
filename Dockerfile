FROM node:10

WORKDIR /usr/src/app

#Define Enviroment variables
ENV PORT 8080

COPY package*.json ./

RUN npm install --only=production

COPY . .

EXPOSE 8080
CMD npm start