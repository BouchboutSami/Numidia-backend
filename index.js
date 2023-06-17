const express = require("express");
const app = express();
const cors = require("cors");
const user = require("./routes/user");
const lieu = require("./routes/lieu");
const { PrismaClient } = require("@prisma/client");
const bodyParser = require("body-parser");
app.use(
  cors({
    origin: "*",
  })
);
const prisma = new PrismaClient();
app.get("/", async (req, res) => {
  const lieux = await prisma.lieu.findMany();
  res.send(lieux);
});

app.use(bodyParser.json());

app.use("/user", user);
app.use("/lieu", lieu);

app.listen(8000, (err) => {
  if (err) throw err;
  console.log("> Ready on http://localhost:8000");
});
