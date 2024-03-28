# **INSTALL GUIDE Infrastructure sécurisée pour BillU**

## _Semaine_S11_

_Date de documentation: 24/01/2024_
__________

## **Besoins initiaux : besoins du projet:**

Dans la continuité de la construction d'une infrastructure réseau sécurisé pour l'entrprise BillU, il a été demandé de réaliserr un audit de sécurité de l'AD avec les outils **PurpleKnight** et **PingCastle**.
Après audit fait, il sera fait une analyse des résultats et des corrections seront apportées si possible. L'objectif de PupleKnight est d'être le plus proche possible de 100%, et de 0/100 pour PingCastle.

______________

## **Choix techniques:**

______________
_______________

# **Étapes d'installation et de configuration : instruction étape par étape:**
___________________

# Installation Purple knight:

![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Pictures/Capture%20d%E2%80%99%C3%A9cran%202024-01-24%20%C3%A0%2014.26.09.png?raw=true)

Pré-requis :

Aller télécharger le fichier zip de Purple Knight-community sur le drive fourni par le DSI.

Extraire le fichier et lancer le commande `dir -Path <emplacement de votre archive depuis la racine exemple "C:"> -Recurse | Unblock-File` depuis un CMD afin de déverrouiller le fichier exécutable de Purple Knight.

![img1](https://github.com/michaelc31/Projet-image/blob/main/PK/Capture1.JPG?raw=true)

Ceci fait lancez l'exécutable afin de procéder à l'Audit.

![img2](https://github.com/michaelc31/Projet-image/blob/main/PK/Capture2.JPG?raw=true)

Accepter les terme de licence cliquez sur suivant, Sélectionnez Active Directory et le Nom de Domaine que vous souhaitez Auditer

![img3](https://github.com/michaelc31/Projet-image/blob/main/PK/Capture3.JPG?raw=true)

Sélectionner le niveau de scan et cliquer sur Run Test

![img4](https://github.com/michaelc31/Projet-image/blob/main/PK/Capture4.JPG?raw=true)

![img5](https://github.com/michaelc31/Projet-image/blob/main/PK/Capture5.JPG?raw=true)

Une fois fini vous obtenez un résultat avec une note.

![img6](https://github.com/michaelc31/Projet-image/blob/main/PK/Capture6.JPG?raw=true)

Pour un audit réussi sur purple Knight faut s'approcher des 100%, vous pouvez à la fin de l'audit voir ou télécharger le rapport en PDF afin de résoudre les problèmes et augmenter votre note.

![img7](https://github.com/michaelc31/Projet-image/blob/main/PK/Capture7.JPG?raw=true)

______________
______________

# Installation PingCastle:

![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Pictures/Capture%20d%E2%80%99%C3%A9cran%202024-01-24%20%C3%A0%2014.26.36.png?raw=true)

Aller télécharger PingCastle [ici](https://www.pingcastle.com/)

Ceci fait décompresser le fichier zip et lancer l'exécutable Ping Castle

![img1](https://github.com/michaelc31/Projet-image/blob/main/PC/Capture1.JPG?raw=true)

![img2](https://github.com/michaelc31/Projet-image/blob/main/PC/Capture2.JPG?raw=true)

Sélectionner l'Option N°1 healthcheck-Score the risk of a Domain afin de lancer l'Audit. et sélectionner le domain sur lequel l'effectuer

![imag3](https://github.com/michaelc31/Projet-image/blob/main/PC/Capture3.JPG?raw=true)

Attendre la fin de l'audit et cliquer sur un touche afin de fermer le programme

![img4](https://github.com/michaelc31/Projet-image/blob/main/PC/Capture4.JPG?raw=true)

L'audit fait les fichiers contenant les rapport seront créé dans le dossier de Ping Castle

![img5](https://github.com/michaelc31/Projet-image/blob/main/PC/Capture5.JPG?raw=true)

Ouvrez le fichier HTML afin de voir le résultat sachant qu'à l'inverse de Purple Knight, Ping Castle doit lui avoir une note au plus près de 0 afin d'avoir un Audit réussi.

![img6](https://github.com/michaelc31/Projet-image/blob/main/PC/Capture6.JPG?raw=true)

Afin de faire descendre la note vous pouvez allez dans le détail du rapport afin de voir les points à rectifier.

![img7](https://github.com/michaelc31/Projet-image/blob/main/PC/Capture7.JPG?raw=true)

Suivre les conseils et aide fourni par le rapport afin de corriger les problèmes, et votre note descendra

![img8](https://github.com/michaelc31/Projet-image/blob/main/PC/Capture8.JPG?raw=true)

![img9](https://github.com/michaelc31/Projet-image/blob/main/PC/Capture9.JPG?raw=true)

# Installation BloodHound:

Pré-requis :

        - Installer Microsoft jdk 11
        - Installer NEO4J-Community edition 5.19

Pour Microsoft jdk 11 Aller [ici](https://learn.microsoft.com/fr-fr/java/openjdk/download#openjdk-11) et sélectionner le fichier selon votre OS. lancer l'exécutable et suivre la procédure en sélectionnant la variable d'environnement pendant l'installation

![img1](https://github.com/michaelc31/Projet-image/blob/main/BloodHound/Capture1.JPG?raw=true)

Pour NEO4J-Community edition aller [ici](https://neo4j.com/deployment-center/#community) sélectionner onglet community version 5.16 sélectionner votre OS et télécharger le fichier zip.

Décompresser le fichier et déplacez vous dans le dossier BIN du dossier Neo4j que vous venez de décompresser. lancer une invite de commande a partir d'ici afin d'exécuter la commande suivante `neo4j.bat install-service`

Le service installé, on va le démarrer avec la commande `net start neo4j` et attendre que le message : `“The neo4j Graph Database - neo4j service was started successfully.”` apparaisse.

Ceci fait on va démarrer un explorateur web et taper http://localhost:7474/ dans la barre de recherche afin de s'authentifier et changer le mot de passe de NEO4J (Passe et user par Defaut neo4j neo4j)

Pour BloodHound aller télécharger le fichier [ici](https://github.com/BloodHoundAD/BloodHound/releases) sélectionner le fichier en fonction de votre OS.

Décompresser le fichier BloodHound et lancer l'exécutable.

![img2](https://github.com/michaelc31/Projet-image/blob/main/BloodHound/Capture2.JPG?raw=true)

connectez vous à la base de données de neo4j et attendre le chargement de BloodHound

![img3](https://github.com/michaelc31/Projet-image/blob/main/BloodHound/Capture3.JPG?raw=true)

lors de notre 1ere connexion à BloodHound il ne nous trouve rien du coup on va aller chercher le fichier ShapE up.ps1 fourni dans le github de BloodHound afin d'effectuer une analyse.

le fichier Sharp Hound.ps1 sur notre ordinateur nous éditons en powershell afin d'exécuter le script et de lancer la commande qui fera l'analyse et créera un fichier ZIP pour bloodhound

    - commande : Invoke-Bloodhound -CollectionMethod All -Domain BillU.lan -ZipFileName Collect.zip

revenir sur BloodHound afin de charger le fichier créé. cliquer sur Upload data sélectionner votre fichier attendre la fin du chargement et vérifier les données récupérées.

![img4](https://github.com/michaelc31/Projet-image/blob/main/BloodHound/Capture4.JPG?raw=true)

![img5](https://github.com/michaelc31/Projet-image/blob/main/BloodHound/Capture5.JPG?raw=true)

![img6](https://github.com/michaelc31/Projet-image/blob/main/BloodHound/Capture6.JPG?raw=true)
