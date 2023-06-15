const express = require("express");
const app = express();
const user = require("./routes/user");
const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();
app.get("/", async(req, res) => {
  const lieux = await prisma.lieu.findMany()
  res.send(lieux) 
});

app.use("/user", user);

app.listen(3000);
