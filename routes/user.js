const express = require("express");
const router = express.Router();
const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();
router.use(express.json())
const bcrypt = require('bcrypt');

router.get("/", function (req, res) {
  res.send("user homepage");
});
router.post('/sign', async (req, res) => {
  
  console.log(1)
  const { nom,prenom,numero_tel,Email,Mdp,pseudo } = req.body;
  
  try {
   
    if (!Email || !Mdp || ! pseudo || !nom || !prenom) {
      return res.status(400).json({ error: 'messing feilds' });
    }

    
    const user_exist = await prisma.utilisateur.findUnique({ where: { Email:Email } });
    if (user_exist) {
      return res.status(409).json({ error: 'deja inscrit' });
    }

    // pour garder la confidencialité 
    const Password = await bcrypt.hash(Mdp, 10);

    
    const User = await prisma.utilisateur.create({
      data: {
        nom : nom,
        prenom : prenom,
        Email : Email,
        pseudo : pseudo,
        Mdp : Password,
        numero_tel : numero_tel,
      },
    });

    return res.json({ message: 'Signup successful', user: User });
  } catch (error) {
    console.error('Error during signup:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
});
router.post('/login', async (req, res) => {
  const { email, password } = req.body;

  try {
   
    if (!email || !password) {
      return res.status(400).json({ error: 'Email and password are required' });
    }

    
    const user = await prisma.utilisateur.findUnique({ where: { Email:email } });

   
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    //comparer le hash de mdp entre
    console.log(user.Mdp)
    const mdpvalide =  await bcrypt.compare(password, user.Mdp);

    if (!mdpvalide) {
      return res.status(401).json({ error: 'Invalid password' });
    }

   

    return res.json({ message: 'Login successful' });
  } catch (error) {
    console.error('Error during login:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
});




module.exports = router;
