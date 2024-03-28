# TSSR-Projet3-Groupe_2-BuildYourInfra

## User-guid BillU

### _Semaine_S12_

### _(Date de documentation: 31 Janvier 2024)_
_______________
## **Besoins initiaux du projet:**
L'infrastructure étant composé de plusieurs serveurs et clients de différents OS, des tests de sécurité sont réalisés cette semaine avec différents outils. Un logiciel IDS/IPS est ajouter au réseau afin d'alerter les anomalies sur le réseau.
______________
## **Choix techniques:**
**Snort** est installé sur le réseau en NIDS comme comme système de détection d'introduction.   
**Kali Linux** est utilisé afin de réaliser les différent tests d'intrusion sur les machines ou le réseau.  
**Nmap** est l'outil utilisé afin de réaliser l'attaque _Scan de ports_.  
**Medusa** est utilisé pour l'_Attaque force brute_ sur un serveur Debian.    
**Ettercap & Wireshark** seront utilisés pour une attaque _Man In The Middle_.

______________
______________

# **Nmap**
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tutos_S12/Nmap.png?raw=true)
___________

## **_Présentation_**

**Nmap** : Outils de scan de ports de réseau.  
**Pré-requis:** Utilisation d'une machine Kali Linux. Nmap est installé de base sur cette distribution. Dans ce lab, la machine de tests d'intrusion est dans le réseau des machines cibles afin de tester les failles éventuelles de celui-ci.
______________
### **_Utilisation_**
Nmap se lance simplement en appellant le logiciel dans un terminale: nmap <options> <AdresseIP_cible>.  
Toutes les options d'utillisations sont sur le site [officiel](https://nmap.org/man/fr/man-briefoptions.html).
______________
Déterminer les hôtes en ligne d'un réseau avec l'option -sP:
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tutos_S12/Nmap%20-sP.png?raw=true)

____________________
Tester les ports ouverts et déterminer les services en écoute et leur version avec l'option -sV:
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tutos_S12/Nmap%20-sV.png?raw=true)
______________________
Déteminer l'OS de la cible avec l'option -O, et -sS afin de pas laisser de trace du scan sur la machine cible:
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tutos_S12/Nmap%20-O.png?raw=true)
______________
Afin de tester des ports spécifique, utiliser l'option -p:
```bash
nmap -p 22; 80; 443; 8080 172.18.1.*
```
**Le wildcard à la fin permet de spécifier tout le réseau 172.18.1.0/24**

Il est également possible de scanner une plage de ports avec la commande suivante pour les ports de 1 à 1000 en exemple:
```bash
nmap -p 1-1000 172.18.1.1
```
______________
______________

# **Medusa**
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tutos_S12/Medusa.png?raw=true)
______________

## **_Présentation_**

**Medusa** : Outils permettent de forcer une connexion ssh en craquant le mot de passe et un nom de session à partir de listes dictionnaire.
**Pré-requis:** Utilisation d'une machine Kali Linux. Medusa est installé de base sur cette distribution. Dans ce lab, la machine de tests d'intrusion est dans le réseau des machines cibles afin de tester la sécurté de connexion ssh de celles-ci.
Une liste au format txt de noms d'utilisateurs aléatoire est généré ainsi qu'une list de mots de passe.
______________
### **_Utilisation_**
L'utilisation de Medusa se fait par un terminale. Avant de commencer le test, s'assurer d'être dans le même emplacement que les fichiers qui seront utilisés lors de l'attaque.
Dans cette exemple, l'emplacement est le **Desktop**:
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tutos_S12/Desk_Kali.png?raw=true)
Lancer la commande sous le format : `medusa -h <AdresseIP_cible> -U <Fichiers_txtUsers> -P <Fichier_txtMotDePasse> -M ssh`
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tutos_S12/Cmd_medusa.png?raw=true)
Le logiciel traitera les 2 fichiers en faisant une combinaison de chaque noms du fichier des utilisateurs à chaque mot de passe du fichier.  
Quand la bonne combinaison est trouvé, la ligne`ACCOUNT FOUND` avec les logins s'affiche:
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tutos_S12/Result_medusa.png?raw=true)
______________
______________

# **Ettercap**
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tutos_S12/Eter_1.png?raw=true)
_____________

## **_Présentation_**

**Ettercap** est un outil de type sniffer, il permet de récupérer les paquet transitant sur un réseaux, notemment les paquets http contenant des logins.
**Pré-requis:** Utilisation d'une machine Kali Linux. Ettercap est installé de base sur cette distribution. Dans ce lab, la machine de tests d'intrusion est dans le réseau des machines cibles afin de tester la sécurté de connexion loggin d'un site. Pour cette exemple, la machine 10.10.10.150 servira de victime, elle sera en écoute afin de récupérer ses logins.
_______________
### **_Utilisation_**
Ettercap est un logiciel graphique. Pour l'utiliser, cliquer sur l'onglet _Applications_ dans la barre de tâches du bureau.  
Cliquer sur le menu `09-Sniffing & Spoofing`, puis cliquer sur `ettercap graphical`.  
Sur la page d'accueil, une fenêtre de configuration de la carte réseau est ouverte. L'option _Sniffing at startup_ est activé et une carte réseau est selectionnée; si ce n'est pas la bonne, cliquer sur le menu déroulant et choisir celle ui convient.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tutos_S12/Eter_2.png?raw=true)
_____________
- Cliquer sur le boutton _Options_ en haut de la fenêtre.
- Si ce n'est pas fait, cocher l'option _Promisc mode_ (Option permettant la remonter d'informations sur la carte réseau)
- Valider le tout en cliquant sur la coche en haut, à côté du boutton Options.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tutos_S12/Eter_3.png?raw=true)
_____________
- Scanner le réseau en cliquant sur l'icône de la loupe en haut de la fenêtre. La console du bas indiquera le résultat de la recherche.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tutos_S12/Eter_4.png?raw=true)
______________
- Pour affiche la liste des machines trouvées, cliquer sur l'icône _Hosts Lists_ se trouvant à côté de la loupe.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tutos_S12/Eter_5.png?raw=true)
_____________
- Cliquer sur la machine _Victime_, 10.10.10.150 dans cette exemple, puis cliquer sur `Add to Target 1`. _Target 1 est le ou les victimes, Target 2 est le ou les destinations des paquets de la victime_. Nous allons écouter les loggins de la victime vers tout le réseau, donc il n'y a pas de _Target 2_. Dans la console, un message de validation s'affiche.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tutos_S12/Eter_6.png?raw=true)
____________
- Cliquer sur le _MITM Menu_ en haut de la fenêtre.
- Cliquer sur _ARP Poisoning_.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tutos_S12/Eter_7.png?raw=true)
___________
- Dans la fenêtre qui s'ouvre l'option _Sniff remote connections_ doit être cocher
- Cliquer sur `OK`
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tutos_S12/Eter_8.png?raw=true)

Un récapitulatif de l'attaque et des cibles s'affiche dans la console.  
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tutos_S12/Etter_9.png?raw=true)
_____________
- Sur la machine Victime, un logging de test est réalisé:
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tutos_S12/Login.png?raw=true)
- Sur la console d' Ettercap on voit apparaître ce login contenant le protocole, le nom d'utilisateur, le mot de passe et la page web utilisé par ce loggin.  
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tutos_S12/Etter_10.png?raw=true)

____________
_____________

# **Wireshark**
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tutos_S12/WS_0.png?raw=true)
____________

## **_Présentation_**

**Wireshark** est un outil de type sniffer, il permet de récupérer les paquet transitant sur un réseaux, notemment les paquets http contenant des logins.  
**Pré-requis:** Utilisation d'une machine Kali Linux. wireshark est installé de base sur cette distribution. Dans ce lab, la machine de tests d'intrusion est dans le réseau des machines cibles afin de tester la sécurté de connexion loggin d'un site. Pour cette exemple, la machine 192.168.1.40 servira de victime, elle sera en écoute afin de récupérer ses logins.
_______________
### **_Utilisation_**
Wireshark est un logiciel graphique. Pour l'utiliser, cliquer sur l'onglet _Applications_ dans la barre de tâches du bureau.  
Cliquer sur le menu `09-Sniffing & Spoofing`, puis cliquer sur `wireshark`.  
- Sur la page d'accueil, sélectionner le périphérique réseau utilisé pour écouter le réseau, **eth1** dans cette exemple.
- Démarrer la capture en cliquant sur l'icône bleu, en forme d'aileron de requin, en haut de la fenêtre.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tutos_S12/WS_1.png?raw=true)
______
- L'écran de capture s'affiche.
- Sur la machine Victime, un logging de test est réalisé:
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tutos_S12/Login.png?raw=true)
- Arrêter la capture en cliquant sur l'icône carré rouge en haut de la fenêtre.
_______
- Dans les trames, chercher celle contenant en adresse source la victime, 192.168.1.40, et dans la colonne **Info** doit être afficher **POST**.
- Sélectionner la en cliquant dessus.
- Dans la fenêtre du bas, cliquer sur `HTML Form URL Encoded: application....`, on retrouve le nom et mot de passe.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tutos_S12/WS_2.png?raw=true)
___________
___________


# **Snort**
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tutos_S12/Snort.png?raw=true)
_____________

## **_Présentation_**

**Snort:** Logiciel permettant l'exploitation d'agents IDS/IPS pouvant être installé sur une machine ou un pare-feu PFSense.  
**Pré-requis**: Avoir une carte réseau en **Promiscuite** afin de pouvoir utilisé l'IDS en NIDS pour le réseau.
_____________

### **_Installation_**

Installation se fait très simplement nous utiliserons un système OS Ubuntu 22.04 :
    
    -   mettre à jour son système avec la commande `sudo apt update && sudo apt upgrade -y`
    -   Installer snort avec la commande `sudo apt install snort -y`

au cours de l'installation de snort le logiciel vous demandera sur quel réseau il travaillera. indiquer le réseau sur lequel votre domaine est actif.

![img1](https://github.com/michaelc31/Projet-image/blob/main/Nouveau%20dossier/Capture.JPG?raw=true)

l'installation fini nous allons vérifier les configurations sur le fichier `/etc/snort/snort.conf`, et changer le paramètre `any` de la ligne `IPvar HOME_NET any` par `IPvar HOME_NET @Reseau`

![img2](https://github.com/michaelc31/Projet-image/blob/main/Nouveau%20dossier/Capture2.JPG?raw=true)

puis nous allons créer nos 1ères règles. Pour ceci nous utiliserons le fichier local.rules qui se situe dans /etc/snort/rules/local.rules et le modifier afin que snort puisse utiliser nos règles.

exemple : 
  
  - création d'une alerte pour tentative de ping : alert tcp $EXTERNAL_NET any -> $HOME_NET any (msg:"tentative de ping"; sid:000001; rev:1;)
  - création d'une alerte pour tentative de connexion ssh : alert tcp $EXTERNAL_NET any -> $HOME_NET 22 (msg:"tentative de connexion SSH"; sid:000002; rev:1;)

![img3](https://github.com/michaelc31/Projet-image/blob/main/Nouveau%20dossier/Capture3.JPG?raw=true)

### **_Utilisation_**

Une fois les règles rédigées dans le fichier `local.rules` nous allons lancer la console snort afin de voir se qui se passe sur notre réseau.

Utiliser la commande sudo snort -C /etc/snort/snort.conf -A console le logiciel se lance 

![img4](https://github.com/michaelc31/Projet-image/blob/main/Nouveau%20dossier/Capture4.JPG?raw=true)

test de ping d'un client vers un autre client sur le réseau, Snort nous affiche notre alerte de tentative de ping créée précédemment.

![img5](https://github.com/michaelc31/Projet-image/blob/main/Nouveau%20dossier/Capture5.JPG?raw=true)
