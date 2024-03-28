# **INSTALL GUIDE Infrastructure sécurisée pour BillU**

## _Semaine_S10_

_Date de documentation: 17/01/2024_
__________

## **Besoins initiaux : besoins du projet:**
Cette semaine les serveurs AD core, Zimbra, Zabbix et GLPI sont tombés en panne et irrécupérables.
Remplacement du matériel défectueux par:
- 2 serveurs DC en Windows CORE avec une configuration de stockage en RAID 1.
- 1 Serveur GLPI sur Debian 11 en RAID 1 pour le stockage.
- IredMail remplace le serveur de messagerie Zimbra à la demande de l'entreprise.
- PRTG remplace le serveur de supervision Zabbix.

Un serveur VoiP sera installé dans l'infrastructure, en y créant des comptes AD et permettent les appels entre les ordinateurs de l'entreprise.  
Les 5 rôles FSMO (Flexible Single Master Operation) seront répartis sur les 3 DC du parc.  
Si possible, un serveur RODC sera installé sur Lyon.  
______________

## **Choix techniques:**
Les serveurs Core seront des Windows Server Core 2022 ainsi que le RODC de Lyon.  
Le serveur Voip sera FreePBX qui correspond au besoin de l'entreprise.  
Les rôles FSMO seront répartie comme ceci:
 - Serveur AD SRVWIN1:
   - Maître RID
   - Contrôleur de schéma
   - Emulateur PDC (Primary Domain Controller)
 - Serveur DC SRVWINC1:
   - Maître d'attribution
 - Serveur DC SRVWINC3:
   - Maître d'infrastructure

Les adresses IP des nouveaux serveurs sont:

| Serveurs BillU | Adresse IP |
|-------|------|
| SRVWINC1 | 172.18.1.210 |
| SRVWINC3 | 172.18.1.211 |
| SRVRODC1 | 10.10.5.210 |
| GLPI | 172.18.1.215 |
| IredMail |172.18.1220 |
| PRTG |172.18.1.202 |
| FreePBX |172.18.1.204|

______________
_______________

# **Étapes d'installation et de configuration : instruction étape par étape:**
___________________


## Configuration d'un VPN sur PFsense :

Objectif : établir une interconnexion de réseau entre notre site de Lyon et Paris.

Utilisation de Pfsense et configurer le VPN en IPsec :
Menu VPN -> IPsec

![pfsense vpn 1](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/assets/146104077/8d51e585-f5a4-4561-a67c-937ca0e44c24)

cliquer sur bouton vert "addP1".

Première étape : Edit Phase 1 : renseigner les éléments pour définir que l'interface WAN de Lyon a une passerelle correspondant au port WAN de PFsense Paris.
Définir une clè dans le champs "Pre-Shared Key" que nous utiliserons pour la configuration du VPN Paris-Lyon.

![pfsense vpn 2](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/assets/146104077/0ef7b691-ce35-4ad5-bdd2-e17cd881fb08)

Laisser les autres éléments par défaut puis sauvegarder.

Passer à la phase 2 : donner une description, puis renseigner que l'adresse IP du réseau LAN de Paris pour que les réseaux LAN communiquent entre eux

![pfsense vpn 3](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/assets/146104077/c3bc9315-80b2-415c-ba04-e254643f9ed4)

sauvegarder

Faire exactement la même démarche de Paris vers Lyon avec les adresses IP adéquates et ajouter la clé défnie plus haut.

Créer une nouvelle règle pour activer le VPN : Firewall->Rules-IPsec puis cliquer sur Add

![pfsense vpn 4](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/assets/146104077/048ec43e-c260-44b3-b6b5-07fdb4830b8f)


Attendre au moins 1 minute pour que Pfsense active cette règle et vérifier si active :
Status->IPsec : established = opérationnel

![pfsense vpn 5](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/assets/146104077/2dd18f6b-64d6-43ab-b580-9387136e4588)

Vpn configuré, vérifier un ping entre machine clientes entre Paris et lyon : opérationnel.

![ping ](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/assets/146104077/2f273ef0-4619-41bd-83c1-02831750e825)
_______________
_______________

## Installation PRTG :

PRTG est un outil de supervision qui sera installé sur un Windows Server 22 indépendant pour analyser le parc informatique du réseau Billu. l'hôte A sera renseigné dans le dns

Pour l'installation aller sur internet et taper PRTG network monitor dans la barre de recherche et télécharger le lien que vous trouvez sur l'url suivant `https://www.paessler.com/fr/prtg`

![img1](https://github.com/michaelc31/Projet-image/blob/main/PRTG/Capture1.JPG?raw=true)

Le logiciel téléchargé, installez le, sélectionner la langue :

![img2](https://github.com/michaelc31/Projet-image/blob/main/PRTG/Capture2.JPG?raw=true)

Accepter les termes de la licence

![img3](https://github.com/michaelc31/Projet-image/blob/main/PRTG/Capture3.JPG?raw=true)

Entrer un adresse Mail afin de recevoir les notifications,

![img4](https://github.com/michaelc31/Projet-image/blob/main/PRTG/Capture4.JPG?raw=true)

Choisir le mode d'installation rapide.

![img5](https://github.com/michaelc31/Projet-image/blob/main/PRTG/Capture5.JPG?raw=true)

![img6](https://github.com/michaelc31/Projet-image/blob/main/PRTG/Capture6.JPG?raw=true)

Sur la page de connection PRTG les identifiants par défaut seront renseignés automatiquement à la premiere connection

![img7](https://github.com/michaelc31/Projet-image/blob/main/PRTG/Capture7.JPG?raw=true)

Page d'accueil de PRTG :

![img8](https://github.com/michaelc31/Projet-image/blob/main/PRTG/Capture8.JPG?raw=true)

## Utilisation de PRTG :

_______________
________________
## Installation FreePBX :

Récuperer l'iso de FreePBX ici https://www.freepbx.org/downloads/ et l'installer dans une nouvelle VM en Linux RedHat.

Au démarrage de la VM, dans la liste, choisir la version recommandée.

![img9](https://github.com/michaelc31/Projet-image/blob/main/PRTG/Capture9.JPG?raw=true)

Puis sélectionnez Graphical Installation - Output to VGA.

![img10](https://github.com/michaelc31/Projet-image/blob/main/PRTG/Capture10.JPG?raw=true)

Enfin choisir FreePBX Standard

![img11](https://github.com/michaelc31/Projet-image/blob/main/PRTG/Capture11.JPG?raw=true)

Pendant l'installation, il faut configurer le mot de passe root (Root password is not set s'affiche).

![img12](https://github.com/michaelc31/Projet-image/blob/main/PRTG/Capture12.JPG?raw=true)

Cliquez sur ROOT PASSWORD et entrez un mot de passe pour le compte root.

`Attention :` le clavier est en QWERTY du coup faire attention au mot de passe mis en place

![img13](https://github.com/michaelc31/Projet-image/blob/main/PRTG/Capture13.JPG?raw=true)

le mot de passe renseigné, l'installation continue et se termine. Redémarrer la VM en enlevant l'ISO avant le redémarrage.

Se connecter en root et mettre son clavier en Francais :

        localectl set-locale LANG=fr_FR.utf8
        localectl set-keymap fr
        localectl set-x11-keymap fr

vérifier que le clavier est en francais avec la commande localectl

![img14](https://github.com/michaelc31/Projet-image/blob/main/PRTG/Capture14.JPG?raw=true)

## Configuration et Mise à jour des Modules FreePBX :

Par l'interface web accessible depuis un client, se connecter en root avec le mot de passe associé et cliquer sur Setup System

Dans la fenêtre, cliquer sur FreePBX Administration et se reconnecter en root. Cliquer sur Skip pour sauter l'activation du serveur et toutes les offres commerciales qui s'affichent. Laisser la langue par défaut et à la fenêtre d'activation du firewall, cliquez sur Abort :

![img15](https://github.com/michaelc31/Projet-image/blob/main/PRTG/Capture15.JPG?raw=true)

A la fenêtre de l'essai de SIP Station cliquez sur Not No. Sur le tableau de bord, cliquez sur Apply Config (en rouge) pour valider tout ce qui a ét réalisé.

![img16](https://github.com/michaelc31/Projet-image/blob/main/PRTG/Capture16.JPG?raw=true)

Activation du serveur (cette activation n'est pas obligatoire), cela permet d'avoir accès à l'ensemble des fonctionnalités du serveur.
Dans le menu Admin puis System Admin.

Cliquez sur Activation puis Activate. Dans la fenêtre qui s'affiche, cliquez sur Activate

![img17](https://github.com/michaelc31/Projet-image/blob/main/PRTG/Capture17.JPG?raw=true)

Entre une adresse email et attendre quelques instants. Dans la fenêtre qui s'affiche, renseignez les différentes informations, et :

        - Pour Which best describes you mets I use your products and services with my Business(s) and do not want to resell it
        - Pour Do you agree to receive product and marketing emails from Sangoma ? cochez No

Cliquer sur Create

![img18](https://github.com/michaelc31/Projet-image/blob/main/PRTG/Capture18.JPG?raw=true)

Dans la fenêtre d'activation, cliquez sur Activate et attendez que l'activation se fasse. Pour les fenêtres qui s'affichent, cliquez sur Skip.

La fenêtre de mise-à-jour des modules va s'afficher automatiquement.
Clique sur Update Now. Attendre la mise-à-jour de tous les modules.

![img19](https://github.com/michaelc31/Projet-image/blob/main/PRTG/Capture19.JPG?raw=true)

Une fois que tout est terminé, clique sur Apply config.

        Il peut y avoir des erreurs sur le serveurs suite à la mise-à-jour des modules et dans ce cas, l'accès au serveur ne se fait pas.
        Les modules incriminés sont précisés et il faut les réinstaller et les activer.
        Dans ce cas, sur le serveur en CLI, exécute les commandes suivantes :

                fwconsole ma install <nom du module>
                fwconsole ma upgradeall (pour mettre a jour les dernier module)

Va sur le serveur en CLI et exécute la commande yum update pour faire la mise-à-jour du serveur. Répondre "y" lorsque cela sera demandé. Et Redémarrer le serveur

## Création ligne utilisateur :

Par l'interface web accessible depuis un client, aller dans le menu Applications puis Poste, fenêtre ci-dessous :

![img20](https://github.com/michaelc31/Projet-image/blob/main/PRTG/Capture20.JPG?raw=true)

Aller sur l'onglet Poste SIP [chan_pjsip] et cliquer sur le bouton + Ajout nouveau Poste SIP [chan_pjsip] et La fenêtre suivante va s'afficher

![img21](https://github.com/michaelc31/Projet-image/blob/main/PRTG/Capture21.JPG?raw=true)

Pour créer la 1ère ligne, celle de Marie Dupont, renseigner les informations suivantes :

        User Extension : 80100
        Display Name : Camille Martin
        Secret : Azerty1*
        Password For New User : Azerty1*

Informations comme ci-dessous :

![img22](https://github.com/michaelc31/Projet-image/blob/main/PRTG/Capture22.JPG?raw=true)

Cliquer sur le bouton Submit puis Apply Config pour enregistrer ton utilisateur.

____________________
## Installation C3Xphone :

Prendre la source ici. (https://3cxphone.software.informer.com/download/)

Télécharger la version x86/x64 sur le site et l'installer sur les 2 clients Windows (pour le test)

## association ligne utilisateurs

Sur le Client N°1 a l'écran du SIP phone, cliquer sur Set account pour avoir la fenêtre Accounts.

![img23](https://github.com/michaelc31/Projet-image/blob/main/PRTG/Capture23.JPG?raw=true)

![img24](https://github.com/michaelc31/Projet-image/blob/main/PRTG/Capture24.JPG?raw=true)

En cliquant sur New, la fenêtre de création de compte Account settings apparaît :
Pour configurer la ligne de l'utilisatrice Marie Dupont, rentre les informations comme ceci :

    Account Name : Camille Martin
    Caller ID : 80100
    Extension : 80100
    ID : 80100
    Password : Azerty1*
    I am in the office - local IP : l'adresse IP du serveur soit 172.18.1.204 (adresse serveur FreePBX)

Cliquer sur Ok tu dois avoir cette fenêtre :

![img25](https://github.com/michaelc31/Projet-image/blob/main/PRTG/Capture25.JPG?raw=true)

Faire de même avec un autre compte utilisateur pour le client 2

## test Communication :

Sur le client 1, taper sur le clavier du SIP phone le numéro 80101 et cliquer sur la touche d'appel (la touche verte). et sur le client 2 on voit l'appel arriver. Répondre en cliquant sur le bouton vert ou refuser l'appel en cliquant sur le bouton rouge

![img26](https://github.com/michaelc31/Projet-image/blob/main/PRTG/Capture26.JPG?raw=true)

___________
___________
## Installation et configuration Iredmail

Prérequis : préparation de l'accueil du serveur dans notre DNS :

créer un Host name A :  mail : 172.18.1.220
Créer un MX : mail : 172.18.1.220

Monter un conteneur de type serveur Debian 12 sur Proxmox.
Faire les mises à jour update && upgrade

Mettre en place la configuration réseau  Ip statique, passerelle, et DNS de notre environnement.

Modifier le fichier /etc/hostname
mettre le nom en FQDN : Full Qualified Domain Name
nous mettons : mail.billu.lan

Modifier le fichier /etc/hosts : 
127.0.0.1 mail.billu.lan localhost

### Installation de iRedMail

commande :

```shell
wget https://github.com/iredmail/iRedMail/archive/refs/tags/1.6.8.tar.gz
```

Extraire avec la commande suivante :

```shell
tar -zxf 1.6.8.tar.gz
```

Se rendre dans le dossier "**iRedMail-1.6.8**" et lancer le script "**iRedMail.sh**".

```shell
cd iRedMail-1.6.8
bash iRedMail.sh
```

Suivre indications du script en mode graphique :
renseigner les champs importants :
notamment le champs du nom de notre domaine comme extension mail  : billu.lan

![iredmail 01](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/assets/146104077/54b2da4b-192a-4170-8811-ed0e2a3e9d5b)

![iredmail 02](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/assets/146104077/f63bbbbc-729b-4d5a-afb3-56ff623b347e)

![iredmail 03](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/assets/146104077/ac3c3bb1-216c-42dc-8e48-fc00263c47f8)

![iredmail 04](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/assets/146104077/0509264e-0ecc-488c-a621-e3251c59e9da)

![iredmail 05](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/assets/146104077/edae8c40-7494-4fe2-9479-a9edf5a482b3)

![iredmail 06](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/assets/146104077/4f035af9-e36b-4e1d-866f-27cadc942871)

![iredmail 07](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/assets/146104077/f5b3d965-ef1c-4810-9e6d-8a680ff5949b)

![iredmail 08](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/assets/146104077/5aa264a9-25d6-4b54-89f7-eb555bc55a57)

![iredmail 09](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/assets/146104077/056f2467-49f9-4c21-b4a0-b4bf54dfc783)

Se connecter à l'interface graphique sur un client sur l'adresse 172.18.1.220
login : postmaster@billu.lan password : Azerty1*

![iredmail 10](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/assets/146104077/08ff6657-b567-4447-bec9-8f229d6875cc)

passer en mode admin pour créer des utilisateurs : 172.18.1.220/iredadmin

Interface de création d'utilsateurs

![iredmail 11](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/assets/146104077/13594126-4ba5-4818-bdc1-cf37397d860d)

ajout

![iredmail 12](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/assets/146104077/f1922d21-875f-433b-816f-d21f9799cb0f)

Utilisation pour un client :
![iredmail 13](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/assets/146104077/264ded1f-cc25-440c-be0f-58709b4ea930)

interface client pour rédaction et réception d'email

![iredmail 14](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/assets/146104077/2f1eec2d-89c3-4779-9c05-bf2b73408218)




_______________
_______________

## Installation RAID1 sur Debian Pour le serveur GLPI

Pour pouvoir initié le *RAID 1* sur l'ensemble de notre disque système nous devons préparer les disques lors du **partitionnement des disques** pendant l'installation de Debian

![img1](https://github.com/michaelc31/Projet-image/blob/main/RAID%20GLPI/Capture1.JPG?raw=true)

Pré-requis avant le lancement de l'installation :

       - Avoir une Machine avec 2 Disques Dur de même capacité vierge (non formaté, non partitionné)

Sur la fenêtre de partitionnement des disques choisir la méthode `Manuel`, la fenêtre suivante affiche les disques détectés avec la table des partitions et les points de montage qui si les disques sont vierge devrait être comme cela :

![img2](https://github.com/michaelc31/Projet-image/blob/main/RAID%20GLPI/Capture2.JPG?raw=true)

Sélectionner le premier disque et créé la table de partition, faire de même pour le 2eme disque. Configuration identique ci-dessous :

![img3](https://github.com/michaelc31/Projet-image/blob/main/RAID%20GLPI/Capture3.JPG?raw=true)

Les tables de partitions créées, utiliser la configuration du RAID par logiciel :

![img4](https://github.com/michaelc31/Projet-image/blob/main/RAID%20GLPI/Capture4.JPG?raw=true)

sélectionner Oui pour appliquer les changements au disque et configurer le RAID :

![img5](https://github.com/michaelc31/Projet-image/blob/main/RAID%20GLPI/Capture5.JPG?raw=true)

les fenêtres suivantes vont nous servir à configurer le RAID, selectionner Créer un périphérique multidisque, sélectionner le Type de RAID souhaité, le nombre de périphériques actif pour l'ensemble du RAID, le nombre de périphériques de réserve pour le RAID :

![img6](https://github.com/michaelc31/Projet-image/blob/main/RAID%20GLPI/Capture6.JPG?raw=true)

![img7](https://github.com/michaelc31/Projet-image/blob/main/RAID%20GLPI/Capture7.JPG?raw=true)

![img8](https://github.com/michaelc31/Projet-image/blob/main/RAID%20GLPI/Capture8.JPG?raw=true)

![img9](https://github.com/michaelc31/Projet-image/blob/main/RAID%20GLPI/Capture9.JPG?raw=true)

les fenêtres suivantes vont vous permettre de sélectionner les disques prévus pour le RAID, et d'appliquer les changements et configurer le RAID :

![img10](https://github.com/michaelc31/Projet-image/blob/main/RAID%20GLPI/Capture10.JPG?raw=true)

![img11](https://github.com/michaelc31/Projet-image/blob/main/RAID%20GLPI/Capture11.JPG?raw=true)

Cliquez sur terminer pour appliquer et configurer le RAID et vous devriez arriver sur la page de partitionnement des disques :

![img12](https://github.com/michaelc31/Projet-image/blob/main/RAID%20GLPI/Capture12.JPG?raw=true)

Le RAID est maintenant prêt, nous allons préparer l'installation du système, revenir sur partitionnement assisté, sélectionner Assisté : utiliser un disque entier :

![img13](https://github.com/michaelc31/Projet-image/blob/main/RAID%20GLPI/Capture13.JPG?raw=true)

![img14](https://github.com/michaelc31/Projet-image/blob/main/RAID%20GLPI/Capture14.JPG?raw=true)

Sélectionner le périphérique RAID créé

![img15](https://github.com/michaelc31/Projet-image/blob/main/RAID%20GLPI/Capture15.JPG?raw=true)

on peut garder tout dans une même partition.

![img16](https://github.com/michaelc31/Projet-image/blob/main/RAID%20GLPI/Capture16.JPG?raw=true)

La fenêtre suivante s'affiche vous avez plus qu'à terminer le partitionnement et lancer l'installation.

![img17](https://github.com/michaelc31/Projet-image/blob/main/RAID%20GLPI/Capture17.JPG?raw=true)

le système installé vous trouverez en lançant la commande `lsblk` les informations suivantes :

![img18](https://github.com/michaelc31/Projet-image/blob/main/RAID%20GLPI/Capture18.JPG?raw=true)
__________________
__________________

## **Création d'un RAID 1 sur un serveur Core**
Le serveur est déjà intégré au domaine et est un serveur DC du domaine en réplication. 
> **Afin de réaliser le RAID 1 de la machine, le disque de stockage doit être en GPT et non en MBR pour se faire.**

Un disque de stockage supplémentaire, de même capacité que l'éxistant, à été ajouté.  

**Sur le serveur AD contrôleur de domaine:**  
Dans le menu _Server Manager_:  
- Cliquer _All Servers_ dans la colonne de gauche.
- Clic droit sur le serveur à manager.
- Cliquer sur _Manage AS..._.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto%20RAID1_Core/6_8.png?raw=true)
_________________

Rentrer le nom et le mot de passe du compte ayant les droits de gestion du serveur.     
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto%20RAID1_Core/7.png?raw=true)
_______________
De retour sur le menu _Server Manager_:  
- Cliquer _All Servers_ dans la colonne de gauche.
- Clic droit sur le serveur à manager.
- Cliquer sur _Computer Management_.  
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto%20RAID1_Core/6_8.png?raw=true)

______________

**Sur le serveur Core:**
- Aller sur la console powershell.
- Taper la commande `diskpart`.
- Taper `list disk`, afin de déterminer le numéro de disque qui a été ajouté. Il est possible de le voir en graphique sur le serveur AD dans _Disk Management_. Le 1 dans ce cas.  
- `Select disk 1`
- `convert dynamic`
- En faisant `list part`, les partitions du disque s'affichent.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto%20RAID1_Core/9.png?raw=true)
____________

**Sur le serveur AD graphique**
Dans la console _Computer Management_:
- Cliquer sur _Disk Management_.
- Les disques doivent être en _Dynamic_ et _Online_. Si ce n'est pas le cas, faire un clic droit sur le nom du disque et les modifier.
- Clic droit sur le disque à répliquer, puis cliquer _Add Mirror_.
- Dans la fenêtre _Add Mirror_, sélectionner le disk de réplication de sauvegarde puis `Add Mirror`.
**_Si une erreur apparaît, refermer la console Computer Management, et recommencer._**
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto%20RAID1_Core/10.png?raw=true)
______________
- Fermer la console _Computer Management_ et y revenir comme précédemment.
- Les deux volumes en mirroir doivent apparaître avec un bandeau rouge. Si ce n'est pas le cas, refermer la console et y revenir.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto%20RAID1_Core/11.png?raw=true)
___________________
___________________
  
## **Répartir les rôles FSMO de L'AD sur les serveurs DC**

Pour savoir quel rôles sont attribués sur quel serveur:
- Dans une console Powershell du serveur AD, taper `Get-ADForest`et `Get-ADDomain`. Cela indiquera les 2 rôles du niveau de la forêt et les 3 du Domaine.  

**Maître d'attributions:**  
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto%20Transfer_r%C3%B4le/1_MasterNaming.png?raw=true)

**Maître de schéma:**  
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto%20Transfer_r%C3%B4le/2_SchemaMaster.png?raw=true)

**Maître d'infrastructure:**  
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto%20Transfer_r%C3%B4le/3_Ma%C3%AEtreInfra.png?raw=true)

**Emulateur PDC:**  
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto%20Transfer_r%C3%B4le/4_PDC.png?raw=true)

**Maître RID:**  
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto%20Transfer_r%C3%B4le/5_RIDMaster.png?raw=true)
____________________

Pour transférer les rôles:
- Dans une console Powershell faire
  ```bash
  Move-ADDirectoryServerOperationMasterRole -Identity "NomDuServeur_Recevant_le_rôle" -OperationMasterRole <Role_Attribuer>
  ```
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto%20Transfer_r%C3%B4le/7.0_Liste.png?raw=true)  
Dans cet exemple on change deux rôles:  
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto%20Transfer_r%C3%B4le/6_Move-ad.png?raw=true)
_________________

Confirmer le changement:
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto%20Transfer_r%C3%B4le/7_Confirm.png?raw=true)

____________________
Vérifier avec `Get-ADForest`et `Get-ADDomain`, les transferts des rôles sur les serveurs:  
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto%20Transfer_r%C3%B4le/8_CheckC1.png?raw=true)
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto%20Transfer_r%C3%B4le/9_CheckC3.png?raw=true)

_____________________
_____________________
