const express = require("express");
const router = express.Router();
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
const bcrypt = require('bcrypt');
const multer = require('multer');
const fs = require('fs');
const { promisify } = require('util');
const upload = multer({storage: multer.memoryStorage()});

router.use(express.json());


  // signup ajoute un admin
  router.post('/signup', async (req, res) => {

    const { Email , Mdp, pseudo, region } =  req.body;

    try{

        if (!Email || !Mdp || ! pseudo || !region) {
            return res.status(400).json({ error: 'missing feilds' });
          }

        const user_exist = await prisma.utilisateur.findUnique({ where: { Email:Email } });
        if (user_exist) {
        return res.status(409).json({ error: 'deja inscrit' });
        }  

         // pour garder la confidencialité 
        const Password = await bcrypt.hash(Mdp, 10);

        const result = await prisma.admin.create({
            data: { 
              Email : Email,
              Mdp : Password,
              pseudo: pseudo,
              region: region},
          })

          return res.json({ message: 'Signup successful', user: result });  
    }
    catch (error) {
        console.error('Error during signup:', error);
        return res.status(500).json({ error: 'Internal server error' });
      }

  });



  // Login Admin


  router.post('/login', async (req, res) => {
    const { Email, Mdp} = req.body;
    try {

    if (!Email || !Mdp ) {
        return res.status(400).json({ error: 'missing feilds' });
        }


    const account = await prisma.utilisateur.findUnique({ where: { Email:Email } });
    if (!account) {
        return res.status(409).json({ error: 'Admin non existant' });
    }  
        


      // pour garder la confidencialité 
      const Password = await bcrypt.hash(Mdp, 10);

      const mdpvalide =  await bcrypt.compare(password, account.Mdp);

        if (mdpvalide) {
            res.status(200).json({ message: 'Login successful', user: account }); 
        } else {
            res.status(400).json({ error: `MDP ghalet hbb` });
        }
    }
    catch (err) {
      res.status(400).json({ error: `Admin avec Email ${Email} n'exsite pas` })
    }
  
   
  });


    // nombre consultation te3 un lieu
    router.get('/Consultlieu/:id', async (req, res) => {
        let idLieu = req.params.id;
        console.log(idLieu);
        try {
    
            const response = await prisma.consulter.count({
            where: {
                idlieu : number(idLieu),
            },
            })
    
            res.status(200).json(response);
    
        } catch (err) {
            res.status(404).json({ error: `Lieu avec ID ${idLieu} n'exsite pas` })
        }
    });


    // les lieux d'un wilaya donne 
    router.get('/wilaya/:id', async (req,res)=>{
        let id = req.params.id
       const lieux = await prisma.wilaya.findMany(
        {
       where : {idwilaya : parseInt(id)  } , 
       include : {
         lieu : true
       }
     }
       )
       if( lieux == null ){ res.send('no data found')}
       else{ res.send(lieux); }
     
     })

    // Consultations Wilaya
    router.get('/consultwilaya/:id', async (req, res) => {
        let idwilaya = req.params.id
        try
            { const lieu = await prisma.lieu.findMany({
                where: {
                  idwilaya : number(idwilaya),  
                }
              })
              if( lieu == null ){ 
                res.status(404).json({ error: `Wilaya avec ID ${idwilaya} n'a pas des lieux ou n'exist pas` })
                }
              let response = 0 ;
      
              for (const l of lieu){
                response = response + await prisma.consulter.count({
                  where: {
                    idlieu: number(l.idLieu),
                }
              })
              } 

              res.status(200).json({message:'numero des consultation',response});
            }
            catch (e) {
                res.status(404).json({ error: `Wilaya avec ID ${idwilaya} n'exsite pas` })
            }
      });



    // Suppression d'un Commentaire

    router.post('/delcomm/:id', async (req,res) => {
        
        let idCommentaire = req.params.id;

        try {
            const comm = await prisma.commentaire.delete({
            where: {
                idCommentaire : number(idCommentaire),
            }
            })
            if (comm) {
                res.status(200).send("Le commentaire a été supprimé");
            } else {
                res.status(404).json({error: `Commentaire non existant` })
            }
        }
        catch (e) {
            res.status(404).json({error: `Erreur lors de la suppression du commentaire`}); 
        }
    
    });


    // Changer l'attribut d'un lieu 


    router.post('/modlieu/:idadmin' ,async(req, res)=>{
        const idadmin = req.params.idadmin
        try {
          const  {idLieu ,nom ,theme ,categorie,description ,tarif , documentation,tempsouverture, tempsfermeture,lat,long,wilaya} = req.body
          const lieu = await prisma.lieu.update({
            where: {  
                idLieu : parseInt(idLieu),
             },
            data:{
                Nom:nom,
                theme:theme,
                categorie:categorie,
                Description:description,
                tarif : parseInt(tarif),
                Documentation:documentation,
                tempsOuverture : tempsouverture,
                tempsFermeture :tempsfermeture ,
                lat : parseInt(lat),
                long : parseInt(long),
                idwilaya :parseInt(wilaya),
                idadmin:parseInt(idadmin)
        }
             })
      
        } 
        catch (error) {
          console.error('erreur a l ajout d un lieu:', error);
          return res.status(500).json({ error: 'Internal server error' });
        }
      
      
      });




    // Ajouter images 

    
        
    router.post('/addpic/:idadmin/:idlieu' ,upload.array('pictures', 5) ,async(req, res)=>{
        const idadmin = req.params.idadmin;
        const idlieu = req.params.idlieu;
        try {
            const lieu = await prisma.lieu.findUnique({
                where: {  
                    idLieu : parseInt(idlieu),
                }
            });


        
        if (lieu){
        
        
            const fileBuffers = await req.files.map((file) => file.buffer);
            fileBuffers.forEach(async(file) => {
                
                const base64Data = file.toString('base64');
                const picutre = await prisma.pictures.create({
                data:{
                    
                    pictures64 :base64Data,
                    idlieu : lieu.idLieu
                }
                })
                if (picutre == null) {
                res.status(500).send('picture cant be sent')
                } 
                })
    
                res.status(200).send('img added successfully')
        }
    
        } 
        catch (error) {
        console.error(`erreur a l ajout d'image:`, error);
        return res.status(500).json({ error: 'Internal server error' });
        }
    
    
    })




  // delete image
  router.post('/delpic/:idadmin/:idimg' ,async(req, res)=>{
    const idadmin = req.params.idadmin;
    const idlieu = req.params.idimg;
    try {
        const image = await prisma.pictures.delete({
            where: {  
                idpictures : parseInt(idimg),
            }
        });
     
    if (img ){
            res.status(200).send('img deleted successfully')
    } else {
        res.status(404).send('img does not exist')
    }
  
    } 
    catch (error) {
      console.error(`erreur delete image:`, error);
      return res.status(500).json({ error: 'Internal server error' });
    }
  
  
  })
