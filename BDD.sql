-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema numidia
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema numidia
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `numidia` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `numidia` ;

-- -----------------------------------------------------
-- Table `numidia`.`admin`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `numidia`.`admin` (
  `idAdmin` INT NOT NULL AUTO_INCREMENT,
  `Email` VARCHAR(45) NOT NULL,
  `Mdp` VARCHAR(45) NOT NULL,
  `pseudo` VARCHAR(45) NOT NULL,
  `region` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idAdmin`),
  UNIQUE INDEX `Email_UNIQUE` (`Email` ASC) VISIBLE,
  UNIQUE INDEX `pseudo_UNIQUE` (`pseudo` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `numidia`.`actualite`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `numidia`.`actualite` (
  `idactualite` INT NOT NULL AUTO_INCREMENT,
  `date` VARCHAR(45) NOT NULL,
  `titre` VARCHAR(45) NOT NULL,
  `idadmin` INT NOT NULL,
  PRIMARY KEY (`idactualite`),
  INDEX `id_adminos_idx` (`idadmin` ASC) VISIBLE,
  CONSTRAINT `id_adminos`
    FOREIGN KEY (`idadmin`)
    REFERENCES `numidia`.`admin` (`idAdmin`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `numidia`.`wilaya`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `numidia`.`wilaya` (
  `idwilaya` INT NOT NULL,
  `nom` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idwilaya`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `numidia`.`lieu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `numidia`.`lieu` (
  `idLieu` INT NOT NULL AUTO_INCREMENT,
  `Nom` VARCHAR(45) NOT NULL,
  `Description` TEXT NOT NULL,
  `tarif` INT NULL DEFAULT NULL,
  `Documentation` TEXT NULL DEFAULT NULL,
  `tempsOuverture` VARCHAR(45) NULL DEFAULT NULL,
  `tempsFermeture` VARCHAR(45) NULL DEFAULT NULL,
  `lat` FLOAT NOT NULL,
  `long` FLOAT NOT NULL,
  `idadmin` INT NULL DEFAULT NULL,
  `idwilaya` INT NOT NULL,
  `theme` ENUM('Nature', 'Divertissement', 'Histoire', 'Hebergement') NULL DEFAULT NULL,
  `categorie` ENUM('Cinéma', 'Hotel', 'Stade', 'Musée', 'Jardin', 'Restaurant', 'Plage', 'Monument', 'Parc', 'Commerce') NULL DEFAULT NULL,
  `icone` BLOB NULL DEFAULT NULL,
  PRIMARY KEY (`idLieu`),
  UNIQUE INDEX `Nom_UNIQUE` (`Nom` ASC) VISIBLE,
  INDEX `idwilaya_idx` (`idwilaya` ASC) VISIBLE,
  INDEX `id_adminos_idx` (`idadmin` ASC) VISIBLE,
  INDEX `id_adminal_idx` (`idadmin` ASC) VISIBLE,
  CONSTRAINT `id_adminal`
    FOREIGN KEY (`idadmin`)
    REFERENCES `numidia`.`admin` (`idAdmin`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `idwilaya`
    FOREIGN KEY (`idwilaya`)
    REFERENCES `numidia`.`wilaya` (`idwilaya`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 35
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `numidia`.`appartient`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `numidia`.`appartient` (
  `idappartient` INT NOT NULL AUTO_INCREMENT,
  `idlieu` INT NOT NULL,
  `idcategorie` INT NOT NULL,
  PRIMARY KEY (`idappartient`),
  INDEX `id_lieuxxx_idx` (`idlieu` ASC) VISIBLE,
  CONSTRAINT `id_lieuxxx`
    FOREIGN KEY (`idlieu`)
    REFERENCES `numidia`.`lieu` (`idLieu`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `numidia`.`utilisateur`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `numidia`.`utilisateur` (
  `idUtilisateur` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `prenom` VARCHAR(45) NOT NULL,
  `numero_tel` VARCHAR(45) NULL DEFAULT NULL,
  `Email` VARCHAR(45) NULL DEFAULT NULL,
  `Mdp` VARCHAR(100) NULL DEFAULT NULL,
  `pseudo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idUtilisateur`),
  UNIQUE INDEX `pseudo_UNIQUE` (`pseudo` ASC) VISIBLE,
  UNIQUE INDEX `Email_UNIQUE` (`Email` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 9
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `numidia`.`avis`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `numidia`.`avis` (
  `idavis` INT NOT NULL AUTO_INCREMENT,
  `note` VARCHAR(45) NULL DEFAULT NULL,
  `LieuId` INT NOT NULL,
  `UtilisateurId` INT NOT NULL,
  PRIMARY KEY (`idavis`),
  INDEX `id_lieux_idx` (`LieuId` ASC) VISIBLE,
  INDEX `id_utilisateurs_idx` (`UtilisateurId` ASC) VISIBLE,
  CONSTRAINT `id_lieux`
    FOREIGN KEY (`LieuId`)
    REFERENCES `numidia`.`lieu` (`idLieu`),
  CONSTRAINT `id_utilisateurs`
    FOREIGN KEY (`UtilisateurId`)
    REFERENCES `numidia`.`utilisateur` (`idUtilisateur`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `numidia`.`categorie`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `numidia`.`categorie` (
  `idcategorie` INT NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`idcategorie`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `numidia`.`commentaire`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `numidia`.`commentaire` (
  `idCommentaire` INT NOT NULL AUTO_INCREMENT,
  `Contenu` VARCHAR(200) NULL DEFAULT NULL,
  `idUtilisateur` INT NULL DEFAULT NULL,
  `id_Lieu` INT NULL DEFAULT NULL,
  PRIMARY KEY (`idCommentaire`),
  INDEX `idUtilisateur_idx` (`idUtilisateur` ASC) VISIBLE,
  INDEX `idlieu _idx` (`id_Lieu` ASC) VISIBLE,
  CONSTRAINT `idlieu_1`
    FOREIGN KEY (`id_Lieu`)
    REFERENCES `numidia`.`lieu` (`idLieu`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `idUser`
    FOREIGN KEY (`idUtilisateur`)
    REFERENCES `numidia`.`utilisateur` (`idUtilisateur`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `numidia`.`consulter`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `numidia`.`consulter` (
  `idconsulter` INT NOT NULL AUTO_INCREMENT,
  `idlieu` INT NOT NULL,
  `idutilisateur` INT NOT NULL,
  PRIMARY KEY (`idconsulter`),
  INDEX `id_user1_idx` (`idutilisateur` ASC) VISIBLE,
  INDEX `id_lieu1_idx` (`idlieu` ASC) VISIBLE,
  CONSTRAINT `id_lieu1`
    FOREIGN KEY (`idlieu`)
    REFERENCES `numidia`.`lieu` (`idLieu`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `id_user1`
    FOREIGN KEY (`idutilisateur`)
    REFERENCES `numidia`.`utilisateur` (`idUtilisateur`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `numidia`.`theme`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `numidia`.`theme` (
  `idtheme` INT NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idtheme`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `numidia`.`contenir`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `numidia`.`contenir` (
  `idcontenir` INT NOT NULL AUTO_INCREMENT,
  `idlieu` INT NOT NULL,
  `idtheme` INT NOT NULL,
  PRIMARY KEY (`idcontenir`),
  INDEX `id__lieu` (`idlieu` ASC) VISIBLE,
  INDEX `id_themos_idx` (`idtheme` ASC) VISIBLE,
  CONSTRAINT `id__lieu`
    FOREIGN KEY (`idlieu`)
    REFERENCES `numidia`.`lieu` (`idLieu`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `id_themos`
    FOREIGN KEY (`idtheme`)
    REFERENCES `numidia`.`theme` (`idtheme`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `numidia`.`favoris`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `numidia`.`favoris` (
  `idfavoris` INT NOT NULL AUTO_INCREMENT,
  `idutilisateur` INT NOT NULL,
  `idlieu` INT NOT NULL,
  PRIMARY KEY (`idfavoris`),
  INDEX `idlieu_idx` (`idlieu` ASC) VISIBLE,
  INDEX `idutilisateur_idx` (`idutilisateur` ASC) VISIBLE,
  CONSTRAINT `idlieu_2`
    FOREIGN KEY (`idlieu`)
    REFERENCES `numidia`.`lieu` (`idLieu`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `idutilisateur_1`
    FOREIGN KEY (`idutilisateur`)
    REFERENCES `numidia`.`utilisateur` (`idUtilisateur`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `numidia`.`horaire`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `numidia`.`horaire` (
  `idhoraire` INT NOT NULL AUTO_INCREMENT,
  `heure` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idhoraire`))
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `numidia`.`moyentransport`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `numidia`.`moyentransport` (
  `idmoyenTransport` INT NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(100) NOT NULL,
  `description` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`idmoyenTransport`))
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `numidia`.`horairetransport`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `numidia`.`horairetransport` (
  `idhoraireTransport` INT NOT NULL AUTO_INCREMENT,
  `id_moyen` INT NOT NULL,
  `id_heure` INT NOT NULL,
  PRIMARY KEY (`idhoraireTransport`),
  INDEX `id_moyen1_idx` (`id_moyen` ASC) VISIBLE,
  INDEX `id_heure1_idx` (`id_heure` ASC) VISIBLE,
  CONSTRAINT `id_heure1`
    FOREIGN KEY (`id_heure`)
    REFERENCES `numidia`.`horaire` (`idhoraire`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `id_moyen1`
    FOREIGN KEY (`id_moyen`)
    REFERENCES `numidia`.`moyentransport` (`idmoyenTransport`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `numidia`.`pictures`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `numidia`.`pictures` (
  `idpictures` INT NOT NULL AUTO_INCREMENT,
  `pictures64` LONGTEXT NULL DEFAULT NULL,
  `idlieu` INT NOT NULL,
  PRIMARY KEY (`idpictures`),
  INDEX `id_lieueuee_idx` (`idlieu` ASC) VISIBLE,
  CONSTRAINT `id_lieueuee`
    FOREIGN KEY (`idlieu`)
    REFERENCES `numidia`.`lieu` (`idLieu`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `numidia`.`traiter`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `numidia`.`traiter` (
  `idtraiter` INT NOT NULL AUTO_INCREMENT,
  `idCommentaire` INT NOT NULL,
  `idAdmin` INT NOT NULL,
  PRIMARY KEY (`idtraiter`),
  INDEX `id_adminal2_idx` (`idAdmin` ASC) VISIBLE,
  INDEX `_id_comm_idx` (`idCommentaire` ASC) VISIBLE,
  CONSTRAINT `_id_comm`
    FOREIGN KEY (`idCommentaire`)
    REFERENCES `numidia`.`commentaire` (`idCommentaire`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `id_adminal2`
    FOREIGN KEY (`idAdmin`)
    REFERENCES `numidia`.`admin` (`idAdmin`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `numidia`.`transport`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `numidia`.`transport` (
  `idTransport` INT NOT NULL AUTO_INCREMENT,
  `id_lieu` INT NOT NULL,
  `id_moyendetransport` INT NOT NULL,
  PRIMARY KEY (`idTransport`),
  INDEX `id_lieu3_idx` (`id_lieu` ASC) VISIBLE,
  INDEX `id_moyen_idx` (`id_moyendetransport` ASC) VISIBLE,
  CONSTRAINT `id_lieu3`
    FOREIGN KEY (`id_lieu`)
    REFERENCES `numidia`.`lieu` (`idLieu`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `id_moyen`
    FOREIGN KEY (`id_moyendetransport`)
    REFERENCES `numidia`.`moyentransport` (`idmoyenTransport`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
