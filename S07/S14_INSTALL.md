# **INSTALL GUIDE Infrastructure sécurisée pour BillU**
## _Semaine_S7_
_Date de documentation: 18/12/2023_
__________

## **Besoins initiaux : besoins du projet:**
installer un serveur Zabbix pour la supervision des serveurs du parc informatique
___________

## **Choix techniques:**

_______________
# **Étapes d'installation et de configuration :**

## Installation serveur Zabbix :

Prérequis pour l'installation sur serveur Debian 11.8  version graphique : LAMP
Zabbix nécessite un serveur web, une base de données MySQL/MariaDB et PHP.

#### Installation d'Apache:

```bash
apt install apache2
```
#### Installation de MySQL/MariaDB:
```bash
apt install mariadb-server
```
Après l'installation, sécurisez MariaDB:
```bash
mysql_secure_installation
```
#### Installation de PHP:

Zabbix 6.4 peut nécessiter PHP 7.4 ou une version plus récente. Installez PHP et les modules nécessaires:

```bash
apt install php php-cli php-common php-mbstring php-gd php-xml php-bcmath php-ldap php-mysql
```

Pour l'installation de Zabbix se rendre sur : 
https://www.zabbix.com/download?zabbix=6.4&os_distribution=debian&os_version=11&components=server_frontend_agent&db=mysql&ws=apache

Choisir la version Debian 11 (bullseye), Server, Mysql, Apache.
##### a. Installation du dépôt Zabbix
```bash
 wget https://repo.zabbix.com/zabbix/6.4/debian/pool/main/z/zabbix-release/zabbix-release_6.4-1+debian11_all.deb  

dpkg -i zabbix-release_6.4-1+debian11_all.deb  

apt update
```

##### b. Installation du serveur Zabbix, frontend, et l'agent
```bash
apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent
```
##### c. Création d'une base de données SQL
```bash
mysql -uroot -p  
Azerty1*
mysql> create database zabbix character set utf8mb4 collate utf8mb4_bin;  
mysql> create user zabbix@localhost identified by 'Azerty1*';  
mysql> grant all privileges on zabbix.* to zabbix@localhost;  
mysql> set global log_bin_trust_function_creators = 1;  
mysql> quit;
```
Sur l'hôte du serveur Zabbix, importez le schéma et les données initiales. Vous serez invité à saisir votre mot de passe nouvellement créé.
```bash
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p zabbix
```
Désactivation de l'option log_bin_trust_function_creators après l'importation du schéma de la base de données.
```bash
mysql -uroot -p  
password  
mysql> set global log_bin_trust_function_creators = 0;  
mysql> quit;
```
##### d. Configurer la base de données su serveur Zabbix

Éditer le fichier de configuration de Zabbix server (`/etc/zabbix/zabbix_server.conf`) et définir les paramètres de la base de données.
```bash
nano /etc/zabbix/zabbix_server.conf
```
Dans ce fichier, chercher et modifier les lignes suivantes avec nos propres valeurs:
```bash
DBHost=localhost DBName=zabbixdb DBUser=zabbix DBPassword=Azerty1*
```
##### e. Démarrer les services du serveur et de l'agent Zabbix

```bash
systemctl restart zabbix-server zabbix-agent apache2  
systemctl enable zabbix-server zabbix-agent apache2
```
##### e. Configuration du frontend Zabbix
Ouvrir un navigateur web et accéder à :
http://localhost/zabbix/ et entrer `Admin` comme nom d'utilisateur et `zabbix` comme mot de passe

![zabbix1](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/assets/146104077/a0bf2fe7-acc3-4d88-95de-b642f1768fd5)

Fenêtre de Zabbix une fois configuré. Se reporter à la section ci-dessous pour intégrer l'infrastructure actuelle de Billu à notre superviseur.

![zabbix2](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/assets/146104077/59ad766d-a9b1-4425-82d6-d30724ba9868)



## Mise en place de l'agent Zabbix 2 sur les serveurs du Parc
### **Pré-requis**
Avoir téléchargé l'agent Zabbix pour les serveurs Windows sur https://www.zabbix.com/fr/download_agents et selectionner le bon fichier en fonction de la version de Zabbix choisi pendant l'installation pour nous ca sera l'agent zabbix 2 v6.4.10

#### Mise en place pour un serveur Windows

Apres avoir téléchargé l'agent lancer l'installation, cliquer sur Next, accepter les termes de licence et cliquer sur next (voir image 1 et 2)

![img1](https://github.com/michaelc31/Projet-image/blob/main/Nouveau%20dossier/Zabbix1.JPG?raw=true)

![img2](https://github.com/michaelc31/Projet-image/blob/main/Nouveau%20dossier/Zabbix2.JPG?raw=true)

La prochaine fenetre propose de selectionner l'emplacement de l'installatyion, laisser par defaut et cliquer sur Next 

![img3](https://github.com/michaelc31/Projet-image/blob/main/Nouveau%20dossier/Zabbix3.JPG?raw=true)

La fenetre de configuration de l'agent arrive et demande le nom de la machine et l'adresse IP du serveur Zabbix, entrer les informations demandées et cliquer sur next puis Install et Finish

![img4](https://github.com/michaelc31/Projet-image/blob/main/Nouveau%20dossier/Zabbix4.JPG?raw=true)

Une fois l'agent installé, verifier le fichier zabbix_agent2.conf qui se trouve dans c:\programme files\Zabbix Agent2\Zabbix_agent2.conf

S'assurer que les lignes suivantes sont correctes :

    Server=@IP_serveur_Zabbix
    ServerActive=127.0.0.1
    Hostname=nom de la machine ou l'agent Zabbix est installer

Une fois le fichier bien configuré, vérification par l'arrêt puis la relance du service Agent Zabbix2 en powershell avec les commandes suivantes

  `get-service -name Agent Zabbix 2`
  
  `Stop-service -name Agent Zabbix 2`
  
  `Start-service -name Agent Zabbix 2`

  `get-service -name Agent Zabbix 2`

Le service etant bien en Running notre configuration client est fini.

#### Mise en place pour un serveur Ubuntu et Debian
*Mise en place ubuntu :*

Lancer la liste de commandes suivante afin d'installer l'agent:
  
    sudo apt update
    wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.4-1+ubuntu$(lsb_release -rs)_all.deb
    sudo dpkg -i zabbix-release_6.4-1+ubuntu$(lsb_release -rs)_all.deb
    sudo apt update
    sudo apt install zabbix-agent2

Une fois installé configurer le fichier zabbix_agent2.conf avec la commande suivante :

    sudo nano /etc/zabbix/zabbix_agent2.conf

Modifier les paramètres suivants :

	    Server=@IP serveur Zabbix
 	    ServerActive=127.0.0.1
	    Hostname=nom de la machine ou l'agent est installer

Relancer le service Zabbix Agent 2 avec les commandes suivantes :

    sudo systemctl start zabbix-agent2
    sudo systemctl enable zabbix-agent2
    sudo systemctl status zabbix-agent2

Le service étant bien en Running notre configuration client est fini.

*Mise en place Debian :*

Lancer la liste de commande suivante afin d'installer l'agent:

    sudo apt update
    wget https://repo.zabbix.com/zabbix/6.4/debian/pool/main/z/zabbix-release/zabbix-release_6.4-1+debian$(lsb_release -rs)_all.deb
    sudo dpkg -i zabbix-release_6.4-1+debian$(lsb_release -rs)_all.deb
    sudo apt update
    sudo apt install zabbix-agent2

Configurer le fichier zabbix_agent2.conf avec la commande suivante :

    sudo nano /etc/zabbix/zabbix_agent2.conf

Modification des paramètres suivants :

	    Server=@IP serveur Zabbix
 	    ServerActive=127.0.0.1
	    Hostname=nom de la machine ou l'agent est installer
 
Relancer le service Zabbix Agent 2 avec les commandes suivantes :

    sudo systemctl start zabbix-agent2
    sudo systemctl enable zabbix-agent2
    sudo systemctl status zabbix-agent2

Le service est bien en mode "Running" notre configuration client est finie.

## Configuration sur le Serveur Zabbix pour la surveillance du Client.

Une fois l'Agent Zabbix installé et configuré passer sur la partie graphique du serveur Zabbix afin de configurer le client.

Se Connecter à l'interface graphique de Zabbix et aller sur l'onglet "Collecte de données/hotes" 

![img5](https://github.com/michaelc31/Projet-image/blob/main/Nouveau%20dossier/Zabbix5.JPG?raw=true)

Création d'un nouvel hôte et renseigner tous les eléments permettant la surveillance de celui ci

![img6](https://github.com/michaelc31/Projet-image/blob/main/Nouveau%20dossier/Zabbix6.JPG?raw=true)

Renseigner le nom de l'hôte (machine où l'agent Zabbix est installé) le modèle "windows by Zabbix Agent", le groupe d'hote auquel il va etre affecté et l'interface en cliquant sur ajouter type "Agent" @IP "IP du serveur à surveiller"  valide.

Apres quelques minutes le nouvel h^pte devrait apparaître en disponible et les informations de surveillance sont disponibles en visuel.

![img7](https://github.com/michaelc31/Projet-image/blob/main/Nouveau%20dossier/Zabbix7.JPG?raw=true)

![img8](https://github.com/michaelc31/Projet-image/blob/main/Nouveau%20dossier/Zabbix8.JPG?raw=true)
