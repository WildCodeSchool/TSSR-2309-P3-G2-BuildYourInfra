# **INSTALL GUIDE Infrastructure sécurisée pour BillU**

## _Semaine_S8_

_Date de documentation: 03/01/2024_
__________

## **Besoins initiaux : besoins du projet:**

## **Choix techniques:**

# **Étapes d'installation et de configuration : instruction étape par étape:**

# Installation de LAPS (Local Administrator Password Solution) :

## Pré-requis :

Afin d'être sûr d'utiliser LAPS et non LAPS legacy nos machines doivent au minimum avoir les mises à jour de sécurité suivantes :

        Win10 : KB5025221
        Win11 : KB5025224
        Winsrv22 : KB5025230

### installation et configuration de LAPS :

Pour installer et configurer LAPS on va passer par powershell en mode administrateur et lancer les commandes suivantes :

    - import-module LAPS : importer le module LAPS ds le serveur
    - get-command -module LAPS : vérifie que le module LAPS est bien installer

![img 1](https://github.com/michaelc31/Projet-image/blob/main/LAPS%20-%20Zimbra/IMG1.JPG?raw=true)

    - update-LapsADSchema -verbose : MAJ de LAPS
    - set-lapsadcomputerselfpermission -identity "OU=Ordinateurs,DC=Billu;DC=lan" : Autorisation de données et/ou modifier le mot de passe pour les Ordinateur présent dans l'OU Ordinateurs

![img 2](https://github.com/michaelc31/Projet-image/blob/main/LAPS%20-%20Zimbra/IMG2.JPG?raw=true)

Suite :

    - copier les fichier LAPS.admx et LAPS.adml dans le dossier sysvol/domain/policyDefinition.
    - Créé la GPO nommé LAPS et configurer la GPO avec les paramètre voulu

![img 3](https://github.com/michaelc31/Projet-image/blob/main/LAPS%20-%20Zimbra/IMG3.JPG?raw=true)

![img 4](https://github.com/michaelc31/Projet-image/blob/main/LAPS%20-%20Zimbra/IMG4.JPG?raw=true)

![img 5](https://github.com/michaelc31/Projet-image/blob/main/LAPS%20-%20Zimbra/IMG5.JPG?raw=true)

Le mot de passe créé par LAPS se trouve dans le gestion des utilisateurs AD dans l'OU ordinateurs en cliquant sur les proprietés du PC

![img 6](https://github.com/michaelc31/Projet-image/blob/main/LAPS%20-%20Zimbra/IMG6.JPG?raw=true)

### Test :

Sélection d'un ordinateur client déjà présent dans l'AD, dans l'OU ordinateurs sur lequel la GPO est active.
Test de connexion au compte Administrateur local de la machine avec le mot de passe d'origine, l'accès est refusé car le mot de passe est incorrect.

![img 7](https://github.com/michaelc31/Projet-image/blob/main/LAPS%20-%20Zimbra/IMG7.JPG?raw=true)

Vérification du mot de passe généré par LAPS en se connectant : "connexion réussi", LAPS gère bien le mot de passe Administrateur Local.

![img 8](https://github.com/michaelc31/Projet-image/blob/main/LAPS%20-%20Zimbra/IMG8.JPG?raw=true)

_______________________
________________________

# Installation de Zimbra 8.8.15 :

## Préparation avant installation de Zimbra :

### Préparation du Serveur AD pour le DNS :

Ouvrir le gestionnaire de DNS afin de créer un nouvel Hôte (A ou AAAA) et un nouveau serveur de messagerie (MX) :

    - clic droit -> nouvel hôte (A ou AAAA) : mettre le nom du serveur Zimbra "ex : srvzimbra" et indiquer son adresse IP "ex : 172.20.0.100"

    - clic droit -> nouveau serveur de messagerie (MX) : nomme identiquement l'hôte créé précédemment et pour le FQDN faire un clic droit sur parcourir et rechercher l'hôte créé précédemment

Test avec la commande `nslookup srvzimbra.billu.lan`

### Préparation du serveur Linux :

Zimbra 8.8.15 étant compatible avec UBUNTU 18.04 LTS nous récupérons un ISO de cette édition via ce lien :

https://releases.ubuntu.com/18.04/

Faire une installation de Linux standard.
Etapes de configuration du serveur pour installer Zimbra une fois l'installation de l'OS terminé :

    - Faire un Update/Upgrade du système : commande `apt update && apt upgrade -y`

    - Installer Apt Ifupdown : commande `apt install ifupdown`

    - Configurer la carte réseau interne pour lui mettre une IP correspondante au Projet : commande `nano /etc/network/interfaces` afin de modifier le fichier interfaces et entre les information adéquate : (exemple à adapter)

                auto lo
                iface lo inet loopback

                auto enp0s3
                iface enp0s3 inet dhcp

                auto enp0s8
                iface enp0s8 inet static
                address 172.20.0.100
                netmask 255.255.255.0
                network 172.20.0.0
                broadcast 172.20.0.255
                dns-nameserver 172.20.0.5
                dns-search billu.lan

![img 9](https://github.com/michaelc31/Projet-image/blob/main/LAPS%20-%20Zimbra/IMG9.JPG?raw=true)

    - Configurer le fichier Hostname : commande `nano /etc/hostname` afin de modifier ou vérifier le nom du serveur "ex : srvzimbra.billu.lan"

    - Configurer le fichier Hosts : commande `nano /etc/hosts` afin de modifier le fichier interfaces et entre les information adequate : "ex : 172.20.0.100    srvzimbra.billu.lan     srvzimbra"
    ligne à placer en premier pour éviter toutes erreurs

    - Configurer le fichier resolv.conf : commande `nano /etc/resolv.conf`

                nameserver 172.20.0.5
                nameserver 1.1.1.1
                search billu.lan

![img 10](https://github.com/michaelc31/Projet-image/blob/main/LAPS%20-%20Zimbra/IMG10.JPG?raw=true)

Penser à rebooter le PC autant que nécessaire afin que les paramètres soient bien pris en compte.

Faire un ping en IPv4 et avec dns "ex : ping 172.20.0.5 ; ex : ping srvzimbra.billu.lan"

![img 11](https://github.com/michaelc31/Projet-image/blob/main/LAPS%20-%20Zimbra/IMG11.JPG?raw=true)

![img 11'](https://github.com/michaelc31/Projet-image/blob/main/LAPS%20-%20Zimbra/IMG11'.JPG?raw=true)

## Installation de Zimbra : Configuration et Utilisation

### 1ere partie : configuration

Le serveur Linux est maintenant prêt à accueillir Zimbra. 
INstallation des apts nécessaires

Commande : `apt install netcat-traditional libidn11-dev libgmp10 sysstat sqlite3 libaio1 unzip pax -y`

Arrêter le service "apparmor" et désactiver le redémarrage auto :

Commande : `service apparmor stop` ; `service apparmor teardown` ; `update-rc.d -f apprmor remove` (bien respecter les caractères pour ce dernier)

Télécharger le zip comprenant Zimbra, commande : `wget https://files.zimbra.com/downloads/8.8.15_GA/zcs-8.8.15_GA_3869.UBUNTU18_64.20190918004220.tgz`

![img 12](https://github.com/michaelc31/Projet-image/blob/main/LAPS%20-%20Zimbra/IMG12.JPG?raw=true)

Décompresser le fichier telechargé, commande : `tar xvzf zcs-8.8.15_GA_3869.UBUNTU18_64.20190918004220.tgz`

Se déplacer dans le dossier "zcs-8.8.15_GA_3869.UBUNTU18_64.20190918004220" et lancer l'installation, commande : `./install.sh`

Répondre "OUI" à toutes les questions sauf install zimbra-dnscache ; install zimbra-proxy ; install zimbra-imapd

![img 13](https://github.com/michaelc31/Projet-image/blob/main/LAPS%20-%20Zimbra/IMG13.JPG?raw=true)

![img 14](https://github.com/michaelc31/Projet-image/blob/main/LAPS%20-%20Zimbra/IMG14.JPG?raw=true)

Afin de finaliser l'installation il reste la dernière phase de configuration avant de pouvoir accéder à l'interface graphique de Zimbra. il faut régler le mot de passe admin de zimbra : option 6 et option 4 afin de changer le mot de passe.

Suite à cette modifictaion de mot de passe, finir l'installation en revenant en arrière avec "r" et en appliquant les changements avec "a" répondre "Oui" à la 1ere question et "Non" à la dernière.

La configuration est terminée, redémarrer le serveur.

### 2eme partie : Utilisation

Zimbra est installé, le serveur est rebooté, se connecter à l'utilisateur Zimbra sur le serveur : se connecter d'abord avec l'utilisateur classique, puis passer en root, et enfin passer en zimbra. ex: connecter vous avec user, passer en root avec `sudo su` une fois en root passer en zimbra avec `su zimbra`

Vérifier et/ou démarrer si nécessaire les services du serveur.

commande : `zmcontrol status` : vérifier le status de tous les services de messagerie

![img 15](https://github.com/michaelc31/Projet-image/blob/main/LAPS%20-%20Zimbra/IMG15.JPG?raw=true)

commande : `zmcontrol start` : démarrera les services si nécessaire

Pour accéder à l'interface graphique se connecter à un client via l'adresse du serveur

        - Pour la console administrateur ex: https://172.20.0.100:7071

        - Pour la boite mail ex: https://172.20.0.100:8443

![img 16](https://github.com/michaelc31/Projet-image/blob/main/LAPS%20-%20Zimbra/IMG16.JPG?raw=true)

![img 17](https://github.com/michaelc31/Projet-image/blob/main/LAPS%20-%20Zimbra/IMG17.JPG?raw=true)

### 3eme partie : Créer une adresse mail pour un compte utilisateur de l'AD:
Dans la console administrateur de l'interface graphique de zimbra, aller dans configurer/domaines, aller sur la roue de paramètre puis cliquer _Add a Domain Alias_.  
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/TutoZimbra/1_AddAlias.png?raw=true)

Le nommer par le nom de domaines du serveur AD.  
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/TutoZimbra/2_Cible.png?raw=true)

Modifier le mode d'authentification du domaine du serveur zimbra. Faire un clic droit sur le nom du serveur et cliquer sur _Configure Authentication_.  
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/TutoZimbra/3_Authentication.png?raw=true)

Lui spécifier un active directory externe.  
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/TutoZimbra/4_Authtication.png?raw=true)

Renseigner le domaine du serveur AD, son adresse IP, fournir l'utilisateur et le mot de passe permettant l'accès au domaine puis tester si la liaison est réussie et enfin cliquer sur terminé.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/TutoZimbra/4bis_Authentication.png?raw=true)

Créer un nouveau compte dans _Manage_/_Accounts_. Cliquer sur la roue de paramètrage puis _New_.  
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/TutoZimbra/5_CreateUser.png?raw=true)

Pour la création du compte récupérer les renseignements d'un utilisateur AD existant ex: Pierre David du Dpt commercial. Pour créer un compte sur zimbra indiquer le nom du compte à l'indentique du compte AD. Valider sans ajouter de mot de passe afin de vérifier que l'on peut se connecter avec le mot de passe de session utilisateurs.

        ex: pierre david sera :
            nom de compte : pdavid@srvzimbra.billu.lan
            nom de famille : pdavid

![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/TutoZimbra/6_CreateUser.png?raw=true)

Afin de tester que Pierre david puisse se connecter aller sur internet adresse https://172.20.0.100:8443 et se connecter avec le nom de compte pdavid mot de passe Azerty2* (mdp pour se connecter à un PC client)

![img 18](https://github.com/michaelc31/Projet-image/blob/main/LAPS%20-%20Zimbra/IMG18.JPG?raw=true)

A l'heure actuelle, les comptes seront créés manuellement afin d'être sûr des informations.

# **Difficultés rencontrées : problèmes techniques rencontrés:**

# **Solutions trouvées : Solutions et alternatives trouvées:**
_____________
_____________

# **Installation de Windows Server Update Services:**
## **Pré-requis :**

Le serveur WSUS est à installer sur un os SERVER windows. Dans ce tuto il s'agit d'un Windows Server 2022.  
Ce serveur doit avoir un espace de stockage libre pour stocker les mises à jours.  
Il doit être renommer, faire partie du réseau du domaine et intégrer à ce domaine.  
Dans cette notice le serveur s'appelle **SRV-WSUS**, son adresse IP est **172.18.1.10** avec comme DNS le serveur AD du domaine **172.18.1.1**. Il est intégrer au domaine BillU.lan.

## **Installation et configuration de WSUS :**
### **Sur le serveur WSUS**:
- Partitionner l'espace de stockage avec l'outil _Computer Management_.
- Dans cette notice le volume est libellé _Save_Updates_ avec comme lettre de lecteur **E:\\**
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto_WSUS/1_Partition.png?raw=true)
________

- Dans le menu _Local Server_, cliquer sur _Add roles and features_, cliquer `NEXT` jusqu'a arriver sur la fenêtre _Server Roles_.
- Cocher le service _Windows Server Update Services_ puis _Next_.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto_WSUS/2_Roles.png?raw=true)
- Cliquer _add features_ puis `Next`. Dans la fenêtre de fonctionnalitées cliquer `Next`.
_________

- Arriver à la fenêtre _Role Services_, cocher _WID Connectivity_ et _WSUS Services_ puis `Next`.  
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto_WSUS/3_WID.png?raw=true)
_________

- Renseigner le path de l'espace de stockage qui sera utilisé pour les mise à jour, E:\\ dans cette notice, puis `Next`.  
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto_WSUS/4_Path.png?raw=true)

__________

- Cliquer sur `Install` sur la fenêtre de récapitulatifs.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto_WSUS/5_INstall.png?raw=true)
________

- Une fois l'installation terminée, cliquer sur le flag en haut de la fenêtre _Local Server_.
- Cliquer sur `Launch Post-Installation tasks`
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto_WSUS/6_Flag.png?raw=true)
_______

- Ouvrir la console Windows Server Update Services via le menu _Windows Administrative Tools_ ou `TOOLS` du _Local Server_.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto_WSUS/7_Console%20WSUS.png?raw=true)
________

- A l'ouverture de la console, WSUS lance le menu de configuration. _Il sera possible de revenir à ces options après si nécessaire via le menu Options de la console WSUS_.
- Cliquer sur `Next` jusqu'a la fenêtre _Upstream Server_.  
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto_WSUS/8_ConfigWSUS.png?raw=true)
_________

- Dans cette fenêtre cocher _Synchronize from Microsoft Update_, afin que le serveur se synchronise aux serveur de Microsoft Update. L'autre option est à cocher si le serveur installer n'est pas le premier et qu'il se connecte à un serveur synchronisé à Microsoft Update.  
- Cliquer sur `Next`.  
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto_WSUS/9_Synchronize.png?raw=true)
- Si nécessaire, renseigner le proxy puis cliquer `Next`.
___________

- La prochaine fenêtre est la connection au serveur de mise à jour qui permet de télécharger les mises à jour. Cliquer sur `Start Connecting`. 
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto_WSUS/10_StartConnecting.png?raw=true)
____________

- Dans la fenêtre _Choose Languages_, il y a deux choix, toutes les langues, ou celles sélectionner. Pour le domaine BillU, il y a des postes en Anglais et Français. Donc l'option _Download updates only in these languages:_ est coché avec les langues _English_ et _French_.
- Cliquer `Next`.  
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto_WSUS/11_Language.png?raw=true)
______________

- Cocher les produits qui seront à mettre à jour, pour le parc BillU il a été coché Windows10 et Windows Server 2022 par exemple.
- Cliquer `Next`.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto_WSUS/12_ChoixProduits.png?raw=true)
_____________

- Choisir la classification des mises à jour à synchroniser. _Critical Updates_ et _Security Updates_ sont le minimum recommandées pour la sécurité.
- Cliquer `Next`.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto_WSUS/13_Classfication.png?raw=true)
______________

- Configurer la fréquence de synchronisation du serveur avec Microsoft Update. Cocher _Synchronize automatically_, régler l'heure de la première synchronisation journalière (2h du matin dans l'exemple), puis le nombre de synchronisation journalières dans le menu déroulant _Synchronizations per day_, 1 étant très suffisant.
- Cliquer `Next`.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto_WSUS/14_Frequence.png?raw=true)
_______________

- Dans la fenêtre _Finished_, _Begin initial synchronization_ est coché, appuyé sur `Next`. _Cette opération peut-être assez longue, elle peut être arrêtée pour faire le reste des configurations, mais devra être relancée manuellement dans le menu de la console WSUS avant la synchronisation des machines du parc_.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto_WSUS/15_Begin.png?raw=true)
______________

- Dans la dernière fenêtre se trouve des liens de topics pour une configuration plus complète. Cliquer sur `Finish`.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto_WSUS/16_Finish.png?raw=true)
_____________


De retour sur la console WSUS: 
- Aller dans _Options_, puis _Automatic Approvals_.
- Dans l'onglet _Update Rules_ cocher _Default Automatic Approval Rule_.
Cela permet d'approuver automatiquement les mises à jour suivant les règles de la section _Rule Properties_ se trouvant en dessous. Il y est réglé qu'une mise à jour Critique ou de Sécurité sont Approuvées sur tout les ordinateurs.
- Cliquer sur _Run Rules_
- Cliquer sur `Apply` et `OK`
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto_WSUS/17_Approvals.png?raw=true)
- Toujours dans le menu _Options_, aller sur _Computers_.
- Cocher l'option _Use Group Policy...._ puis validé.
_______

Sur la console WSUS:
- Cliquer sur le nom du serveur.
- Cliquer sur _Computers_ puis clic droit sur _All Computers_.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto_WSUS/18_AddGroup.png?raw=true)
- Cliquer sur _Add Computer Group_ et le nommer. Pour cette notice, 2 sont créés. Ceci est à adapter suivant l’infrastructure du parc et la politique de gestion des mises à jour.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto_WSUS/19_Group.png?raw=true)
__________
 
 Le serveur WSUS est prêt, il faut maintenant gérer le parc via le serveur Active Directory du parc.
 **Sur le serveur AD:**
 - Aller dans le gestionnaire _Group Policy Management_
 - Créer 3 GPO nommer pour l'exemple:
           - WSUS_Communs, qui sera utilisé pour tout les groupes du serveur WSUS.
           - WSUS_PC, Utilisé pour les machines qui seront dans le groupe _PC_ du serveur WSUS.
           - WSUS_Serveurs, Utilisé pour les machine qui seront dans le groupe _Serveurs_ du serveur WSUS.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto_WSUS/20_GPOmanage.png?raw=true)
____________

- Editer la GPO WSUS_Communs
- Aller dans _Computer Configuration_--> _Policies_--> _Administrative Templates_--> _Windows Components_--> _Windows update_  
  - #### **Si le dossier _Administrative Templates_ est vide:**   
    - Copier le dossier C:\Windows\PolicyDefinitions\en-US _(en-US pour les serveur en Anglais, il est possible de copier fr-FR pour un serveur en français par exemple)_  
    - Coller le dossier dans Network\NomDuServeur\SYSVOL\NomDeDomaine\Policies\PolicyDefinitions _(Si le dossier PolicyDefinitions n'éxiste pas, il faut le créer)_
                  ![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto_WSUS/20.2_GpoManage.png?raw=true)
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto_WSUS/21_WinSett.png?raw=true)
- Cliquer sur _Specify intranet Microsoft update service location_, qui indiquera ou est le serveur de mise à jour. 
- Cocher _Enabled_
- Dans la case Options, rentrer l'adresse du serveur WSUS avec le port 8530 dans les deux cases.  
- Cliquer sur `Apply`puis `OK`.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto_WSUS/23_GPO1C.png?raw=true)
- Cliquer sur _Configure Automatic Updates_, qui configure les mises à jour des machines.
- Cocher _Enabled_.
- Dans la case Options:
        - Dans _Configure automatic updating_ , sélectionner _4- Auto Download and schedule the install_ qui permet de télécharger automatiquement les mises à jour et de planifier l'installation.
        - Sélectionner le jour de l'installation planifiée dans _Scheduled install day_
        - Sélectionner l'heure de l'installation dans _Scheduled install time_
        - Cocher quelle semaine faire les mises à jour, cocher _Third_ et _Fourth week of the month_. Cela est  suffisant pour les mises à jour Windows.
        - Cocher la case _Install updates for other Microsoft products_
- Cliquer sur `Apply`puis `OK`.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto_WSUS/24_GPO2C.png?raw=true)
- Cliquer sur _Do not connect to any Windows Update Internet locations_ qui permet de bloquer la connectiion des machines vers les serveurs de mise à jour Windows sur internet.
- Cocher _Enabled_.
- Cliquer sur `Apply`puis `OK`.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto_WSUS/25_GPO3C.png?raw=true)
_________________

- Editer la GPO WSUS_Serveur
- Aller dans _Computer Configuration_--> _Policies_--> _Administrative Templates_--> _Windows Components_--> _Windows update_
- Cliquer sur _Enable client-side targeting_, qui permet d'envoyer les machines dans les bons groupes de WSUS.
- Cocher _Enabled_.
- Dans la case Options, rentrer le nom du groupe des machines de cette GPO dans l'espace _Target group name for this computer_, Serveurs pour cette exemple.
- Cliquer sur `Apply`puis `OK`.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto_WSUS/27_GPO2SRV.png?raw=true)
- Cliquer _Turn off auto-restart for updates during active hours_ qui permet d'empêcher les machines de redémarrer après l'installation d'une mise à jour pendant leurs heures d'utilisations.
- Cocher _Enabled_.
- Dans la case Options, régler les heures d'activités pendant lesquelles la machine ne devra pas s'arrêter pour redémarrer.
- Cliquer sur `Apply`puis `OK`.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto_WSUS/28_GPO1SRV.png?raw=true)
____________________

-Editer la GPO WSUS_PC
- Faire la même chose que la GPO WSUS_Serveurs en adaptant le nom du groupe cible par PC et non Serveurs ainsi que les heures d'activités qui sont différentes des serveurs.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto_WSUS/26_GPO1PC.png?raw=true)

Ne pas oublier de mettre les politique de filtrage et le scope correspondant à chaque GPO
_______________

Dans la console _Group Policy Management_:
- Lier les GPO créés aux OU des machines adéquates. Dans cette exemple, WSUS_communs est liée à l'OU Ordinateur, WSUS_Serveurs au sous-OU Serveurs et WSUS_PC au sous-OU DptCommercial.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto_WSUS/29_LinkGPO.png?raw=true)
____________________

Sur les machines client et serveurs:
```bash
gpudate /force
```
puis les redémarrer.
___________

**Sur le serveur WSUS**
- Sur la console WSUS cliquer sur le nom du serveur.
- Cliquer sur _Computers_, _All Commputers_ et les groupes des machines. Si elle ne s'affiche pas, appuyer sur _Refresh_.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto_WSUS/30_PolitiqueGPO.png?raw=true)
Si les machines ne s'affiche pas, Aller dans le menu de gestion des mises à jour de la machine à remonter sur le serveur WSUS, puis lancer une mise à jour. Un message de gestion interne apparaît.
___________

**Gérer les MAJ**
- Dans la console WSUS, cliquer sur _Updates_.
- Cliquer sur un des critères: _All Updates_, _Critical_, _Security_ ou _WSUS_ ce dernier étant pour le serveur WSUS.
- Sélectiionner un filtre en haut du tableaux de droite.
- Clic droit sur la mise à jour voulu puis choisir entre _Decline_ pour ne pas l'utilisée et elle sera supprimée ou _Approve_ pour qu'elle soit approuvée et installée en sélectionnant les groupes concernés 
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto_WSUS/31_Decline.png?raw=true)
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto_WSUS/32_Approve.png?raw=true)
Il est possible de créer soi-même des filtres de recherches de mise à jour. Pour cela cliquer sur _New Update View_ à droite de la fenêtre.
- Selectionner les propriétés de mise à jour voulus
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto_WSUS/34_Specific.png?raw=true)
- Choisir les produits dans la case du dessous
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto_WSUS/35_Choose.png?raw=true)
- Nommer le filtre et valider avec `OK`
- Il apparaît dans la liste.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/Tuto_WSUS/37_Filter.png?raw=true)





# **Difficultés rencontrées : problèmes techniques rencontrés:**

# **Solutions trouvées : Solutions et alternatives trouvées:**
