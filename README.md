# **Dinosaur API**

This is an example project. The purpose of this API is to create an example of how to retrieve Data from a MySQL database over an express JS API.

**Diagram**:

![](https://slabstatic.com/prod/uploads/8q5jdj6q/posts/images/re0hVfmJQxWdcC9TXWeuZfLv.png)

Used technologies:

- Nodejs → javascript runtime
- Typescript → javascript typesystem
- Express → API framework
- Flutter → Frontend framework
- Prisma → database ORM
- MySQL → database
- Docker  → Containerservice
- Cloud Run → hosting the API server and the frontend webserver
- GCE SQL → hosting database
- VPC Network → connecting database with API



Code on GitHub: [https://github.com/Megakuul/api.gehege.ch](https://github.com/Megakuul/api.gehege.ch)

# Code



### Preparation

I used docker desktop and MySQL workbench to test the application

The first step is to initialize node project:

```bash
npm init -y
```

Then install express:

```bash
npm install express
```

Install CORS middleware:

```dockerfile
npm install cors
```

Install Prisma:

```bash
npm install prisma --save-dev
```

To enable Prisma syntax highlighting, you have to install the Prisma extension from the VS Code extensions.

Install Typescript:

```bash
npm install typescript ts-node @types/node --save-dev
```

Create tsconfig.json file:

```javascript
tsc --init
```

Add these lines to the tsconfig.json file:

```javascript
{
  "compilerOptions": {
    "sourceMap": true,
    "outDir": "dist",
    "strict": true,
    "lib": ["esnext"],
    "esModuleInterop": true
  }
}
```



### Create API

It is recommended to enable Typescript watch mode (live compilation). In VS Code, this can be achieved with **CTRL-B → Watch**.

It is very important to use the CORS middleware, without this you will not be able to send requests from a client

First create a basic express application (in the index.ts file):

```javascript
const express = require("express");

//Take the port from an environment variable
const port = process.env.PORT;

const app = express();
//With this cors module, we enable traffic from other clients to our API
const cors = require('cors');
//If we declare it like so, it will allow all traffic
app.use(cors());

app.use(express.json());

//Handle requests for the root (/)
app.get("/", (req, res) => {
    res.send("<p>Hello World</p>");
});

app.listen(port, () => {
    console.log("server exposed on port: " + port);
});
```

Test it with `node index.js`

Then create init a Prisma project

```bash
npx prisma init --datasource-provider mysql
```

Variables like &quot;**process.env.PORT**&quot; as well as the database hostname can be added to the **.env** file.

Prisma has a built-in schema, this schema then gets applied to the database.

Now we have to build the Prisma schema in the **schema.prisma** file:

```javascript
// This is your Prisma schema file,
// learn more about it in the docs: https://pris.ly/d/prisma-schema

generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "mysql"
  url      = env("SQLHOST")
}

model dinosaur {
  id        Int @id @default(autoincrement())
  name      String @db.VarChar(255)
  food      food @relation(fields: [foodId],references: [id])
  foodId    Int

  @@index(foodId)
}

model food {
  id        Int @id @default(autoincrement())
  name      String @db.VarChar(255)
  dinosaurs dinosaur[]
}
```

To migrate the schema to the database, run (reset to hard reset the database):

```bash
npx prisma migrate reset
```

Or run deploy if the database is in production

```javascript
npx prisma migrate deploy
```

Now we have to create the JS Library to interact with the database:

```bash
npx prisma generate
```

Migrate Tables etc. in development

```javascript
npx prisma migrate dev --name [name]
```

Pull Schema from existing database

```javascript
npx prisma db pull
```

Add the output to the TS file, this should look like this:

```javascript
import { PrismaClient } from '@prisma/client'
const prisma = new PrismaClient()
```

Now we can use the prisma object to handle all database selects/inserts etc. (example)

```javascript
const newdinosaur = req.body;

    const dinosaur = await prisma.dinosaur.create({
        data: {
            name: newdinosaur.name,
            description: newdinosaur.description,
            creator: newdinosaur.creator
        }
    });
```



### Create frontend

To read the data from the API, we need to have a user-friendly graphical interface. For this, you can choose your favorite frontend Framework. In this example, I used Flutter.

How you design the frontend is up to you, but here is an example of how to read the data from the API with Dart:

```csharp
Future<List<dynamic>> fetchDinosaurs(String uri) async {
  final response = await http.get(Uri.parse(uri));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load Dinosaurs');
  }
}

late Future<List<dynamic>> dinosaurs = fetchDinosaurs("https://api.gehege.ch/dinosaurs");
```



### Dockerfile

To build the Dockerfile, you need docker to be installed

Create a `Dockerfile` and add something like this:

```dockerfile
#Set base image
FROM node:14

#Set workdir inside container
WORKDIR /usr/src/app

#Define Enviroment variables if needed, in our example we give the Port in the Google Cloud Run config, so we dont need it here
#ENV PORT 8080

#Copy package.json file and prisma migrations into the Container
COPY package*.json ./
COPY prisma ./prisma/

#Install every package defined in package.json file
RUN npm install --only=production

COPY . .

#Define CMDs that are getting executed on container start
CMD npm start
```

To make the `npm start` command work, we need to add something like that in the package.json file:

```javascript
  "scripts": {
    "start": "node index.js"
  }
```

Then build the Dockerfile with:

```bash
docker build ./
```

Now we can find the docker image with the `docker images` command.



For the frontend, we will use a nginx base image:

```dockerfile
#Set base image
FROM nginx:latest

#In this case we will directly integrate the Environment variable (because its very unlike to change)
ENV API_URL api.gehege.ch

#Copy the files to the nginx HTML root
COPY ./build/web /usr/share/nginx/html
#Optionally we could also copy a nginx.conf file to add additional configuration to the webserver
#COPY nginx.conf /etc/nginx/nginx.conf

#Set nginx Workdir
WORKDIR /usr/share/nginx/html

#Start nginx without daemon
CMD ["nginx", "-g", "daemon off;"]
```

# Google Cloud



### Deploy API

To deploy this, we will need the **gcloud** CLI tool installed.

To deploy the API, we first want to build the docker file:

```bash
docker build ./
```

Now you have to authenticate yourself with the gcloud credential manager:

```bash
gcloud auth login
```

Configure docker with the gcloud credential manager:

```bash
gcloud auth configure-docker
```

To execute push commands, you have to add your user to the **docker-users** local group (normally this is already the case):

```bash
net localgroup docker-users DOMAIN\USERNAME /add
```

Then you have to tag the docker image (image-name is defined by you):

```bash
docker tag [imageid] eu.gcr.io/[yourprojectid]/[image-name]
```

To push it to the Google Cloud container registry, enter:

```bash
docker push eu.gcr.io/[yourprojectid]/[image-name]
```

You can review the Image in the **Container Register** service.



Now, in the **Cloud Run** section on Google Clouds console, you can create a new service and select the deployed image. Under &quot;**Environment Variables**&quot; you can specify the environment variables like the Database IP etc.

To use the Database, we have to add it in the Cloud Runs **Connection** tab:

![](https://slabstatic.com/prod/uploads/8q5jdj6q/posts/images/_icFZLbFA5fU3srjwLHKfHaK.png)



### VPC Network

VPC Network is the service GCE uses to create private networks inside the cloud.

These steps could also be done in the GUI

In the VPC Network section, you can create a private network. In my case, I called it &quot;**dinosaur-api-network**&quot;. This network will create a connection between the database and the API.

```bash
gcloud compute networks create [networkname]
```

For this step, the SQL instance has to be stopped.

Then we need to set the database network, on creation of the SQL-Instance we can do this like so:

```bash
gcloud sql instances create [instancename] --network=[networkname]
```

Or after creation:

```bash
gcloud sql instances patch [instancename] --network=[networkname]
```

Now we have to use a VPC connector (needs the VPC connector API to be enabled) to connect the Cloud Run service:

```bash
gcloud compute networks vpc-access connectors create [connector-name] --region=[region (ex. europe-west6)] --network=[peer network] --range=10.8.0.0/28
```

Connect Cloud Run service:

```bash
gcloud beta run services update [servicename] --vpc-connector=[networkname]
```



### Database



The database is deployed with the **Cloud SQL** service. The schema can be migrated through **prisma** or how I did it manually with the **migration.sql** file.



The database uses a specific user, in this case I called it &quot;**api**&quot;. You can specify the user at your own, it&#39;s important that the user has a **strong password**.

![](https://slabstatic.com/prod/uploads/8q5jdj6q/posts/images/fnUhOe-TUwf9l2TsKI099XJ-.png)

The credentials for the &quot;**api&quot;** user are specified in the environment variable of the API container.



It&#39;s important that under &quot;Connections&quot; the Network with the VPC Connector for the Cloud Run Container is the same as specified in the Database:

![](https://slabstatic.com/prod/uploads/8q5jdj6q/posts/images/zL7-piR_Qh9oOZQc_jsszb8Z.png)

I would not recommend using a public IP.



In the APIs Environment variables, we can now set the SQLHOST properties to the following:

```dockerfile
SQLHOST=mysql://<api>:<secretpassword>@<privateip>:3306/<database>
```



If everything is correctly configured, the API should now be able to connect to the database.
