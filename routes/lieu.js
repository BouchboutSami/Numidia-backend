const express = require("express");
const router = express.Router();
const { PrismaClient } = require("@prisma/client");
const multer = require("multer");
const fs = require("fs");
const { promisify } = require("util");
const upload = multer({ storage: multer.memoryStorage() });
router.use(express.json());
const prisma = new PrismaClient();

//tous les lieux
router.get("/all", async (req, res) => {
  const lieux = await prisma.lieu.findMany();
  res.send(lieux);
});
// les lieux d'un wilaya donne
router.get("/wilaya/:id", async (req, res) => {
  let id = req.params.id;
  console.log(id);
  const lieux = await prisma.wilaya.findMany({
    where: { idwilaya: parseInt(id) },
    include: {
      lieu: true,
    },
  });
  if (lieux == null) {
    res.send("no data found");
  } else {
    res.send(lieux);
  }
});
//la moyenne d''un lieu donne
router.get("/moyen/:idlieu", async (req, res) => {
  let idlieu = parseInt(req.params.idlieu);

  const data = await prisma.lieu.findMany({
    where: { idLieu: idlieu },
    include: { avis: true },
  });

  if (data == null) {
    res.send("no data found");
  } else {
    const avis = data[0].avis;
    if (avis.length == 0) {
      res.json({ message: "lieu non noté" });
    } else {
      const totalavis = avis.length;
      const sum = avis.reduce((acc, i) => acc + parseInt(i.note), 0);
      const moyen = sum / totalavis;

      res.send(moyen.toString());
    }
  }
});
// les commentaires d'un lieu donne
router.get("/comments/:idlieu", async (req, res) => {
  let idlieu = parseInt(req.params.idlieu);

  const data = await prisma.lieu.findMany({
    where: { idLieu: idlieu },
    include: { commentaire: true },
  });

  if (data == null) {
    res.send("no data found");
  } else {
    comments = data[0].commentaire;
    if (comments.length == 0) {
      res.json({ message: "no commentaire" });
    } else {
      list = await comments.map(async (com) => {
        let idutilisateur = com.idUtilisateur;

        let name = await prisma.utilisateur.findFirst({
          where: { idUtilisateur: idutilisateur },
        });

        return { contenu: com.Contenu, utilisateur: name.nom };
      });
      const resultArray = await Promise.all(list);
      res.send(resultArray);
    }
  }
});
module.exports = router;
router.post("/add/:idadmin", upload.array("pictures", 5), async (req, res) => {
  const idadmin = req.params.idadmin;
  try {
    const {
      nom,
      theme,
      categorie,
      description,
      tarif,
      documentation,
      tempsouverture,
      tempsfermeture,
      lat,
      long,
      wilaya,
    } = req.body;
    const lieu = await prisma.lieu.create({
      data: {
        Nom: nom,
        theme: theme,
        categorie: categorie,
        Description: description,
        tarif: parseInt(tarif),
        Documentation: documentation,
        tempsOuverture: tempsouverture,
        tempsFermeture: tempsfermeture,
        lat: parseInt(lat),
        long: parseInt(long),
        idwilaya: parseInt(wilaya),
        idadmin: parseInt(idadmin),
      },
    });
    if (lieu != null) {
      if (!req.files || req.files.length === 0) {
        return res.status(200).send("lieu created without pictures.");
      } else {
        const fileBuffers = await req.files.map((file) => file.buffer);
        fileBuffers.forEach(async (file) => {
          const base64Data = file.toString("base64");
          const picutre = await prisma.pictures.create({
            data: {
              pictures64: base64Data,
              idlieu: lieu.idLieu,
            },
          });
          if (picutre == null) {
            res.status(500).send("picture cant be send");
          }
        });

        res.status(200).send("lieu created successfully");
      }
    }
  } catch (error) {
    console.error("erreur a l ajout d un lieu:", error);
    return res.status(500).json({ error: "Internal server error" });
  }
});

router.get("/pictures/:idlieu", async (req, res) => {
  const idlieu = req.params.idlieu;
  try {
    const pictures = await prisma.pictures.findMany({
      where: {
        idlieu: parseInt(idlieu),
      },
    });
    if (pictures == null) {
      return res.status(204).json({ message: "no pictures for this place" });
    } else {
      res.send(pictures);
    }
  } catch (error) {
    console.error("erreur a l ajout d un commentaire:", error);
    return res.status(500).json({ error: "Internal server error" });
  }
});
//transport d'un lieu
router.get("/transport/:idlieu", async (req, res) => {
  let id_Lieu = parseInt(req.params.idlieu);
  try {
    const moyen = await prisma.transport.findMany({
      where: { id_lieu: id_Lieu },
    });
    if (moyen == null) {
      return res.status(204).json({ message: "no transport for this place" });
    } else {
      moyendetrans = await moyen.map(async (moy) => {
        data = await prisma.moyentransport.findFirst({
          where: { idmoyenTransport: moy.id_moyendetransport },
        });
        horraire = await prisma.horairetransport.findMany({
          where: { id_moyen: data.idmoyenTransport },
        });
        heures = await horraire.map(async (hor) => {
          datahor = await prisma.horaire.findMany({
            where: { idhoraire: hor.id_heure },
          });

          return datahor[0].heure;
        });
        const heuremoy = await Promise.all(heures);

        return { data, heuremoy };
      });
      const listtansport = await Promise.all(moyendetrans);
      res.send(listtansport);
    }
  } catch (error) {
    console.error("Error during fetching :", error);
    return res.status(500).json({ error: "Internal server error" });
  }
});

router.get("/actualites", async (req, res) => {
  const actualites = await prisma.actualite.findMany();
  res.send(actualites);
});
