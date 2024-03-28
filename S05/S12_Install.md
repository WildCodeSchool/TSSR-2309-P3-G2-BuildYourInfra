# **INSTALL GUIDE Infrastructure sécurisée pour BillU**
## _Semaine_S5_
_Date de documentation: 07/12/2023_

## **Besoins initiaux : besoins du projet:**

Réalisation d'une infrastructure sécurisé pour l'entreprise BillU. Un domaine AD a été installé et complété par un serveur de gestion de mot de passe pas encore opérationnel ainsi qu'un deuxième serveur DC avec réplication. Gestion automatique des salariés de la société dans le répertoire AD.   
Un serveur GLPI a été mis en place afin de gérer le parc informatique et le ticketing pour la maintenance. Une dizaine de GPO a été créées dans l'AD.  
**Cette semaine** un pare -feu PFSense a été installé sur chaque site, Paris et Lyon. La Télémétrie des postes Windows a été traitée. Un script appelé Télémétrie_Management a été créé afin de désactiver certains services de télémétrie présent sur les postes.

## **Choix techniques:**

Les  pare-feus sont des PFSense fournis par le DSI de l'entreprise BillU.  
La Télémétrie est gérée par un script appliqué pae une GPO sur les ordinateurs afin de faciliter l'évolution de la gestion de cette télémétrie.

# **Etapes d'installation et de configuration:**

## **Script telemetry:**

Le script de télémétrie a été créé  et sauvegarder sur le serveur AD, l'accès se fait via un dossier partagé. Le lancement se fait automatiquement a chaque connection d'utilisateur via une GPO (voir S11) créé sur le serveur AD.

Ce script réalise les tâches suivantes: 
 - Vérifie les registres et les cles de registre afin de les créer ou les modifier.  
 - Il désactive la télémétrie, Adverting ID, SmartScreen, OneDrive, DiagTrack, la géolocalisation entre autres.
 - Il désactivee également les sevices : skype, cortana, GrooveMusic, Film et TV ...

## **Script AD:**

Mise a jour du script afin d'organiser automatiquement  les utilisateurs dans les groupes AD en fonction de leur service et/ou departement. 

## **PFSense:**
PfSense se monte sur un OS BSD propre à à ce constructeur.  
Pour l'installation suivre ce tuto complet: [Vidéo](https://www.youtube.com/watch?v=NzVDjNqchoc).  
Au vue du réseau actuel, des informations portées à notre connaissances à ce jour et après plusieurs tests, il s'est avéré que les règles par de défaults conviennent aux besoins du projet à ce stade. Les 2 sites ont les règles de pare-feu par défault leurs permettant de communiquer vers l'extèrieur sans pouvoir être vue depuis l'èxtérieur. Les sites n'étant pas encore en communication cela est sufisant pour leur sécurité.


## **Difficultés rencontrées : problèmes techniques rencontrés:**

1. PING persistant (proxmox).
2. Application du script de télémétrie en partage sur les ordinateurs de l'AD.


## **Solutions trouvées : Solutions et alternatives trouvées:**

1. Installation d'un nouveau PFSENSE.
2. Le script partagé est placé dans le dossier Syslog. 

## **Tests réalisés : description des tests de performance, de sécurité, etc.:**
- Test de communication depuis l’extérieur sur les réseaux avec filtrage des pare-feu.  
- Test des GPO en place sur l'AD.  
- Tests de l'apllication du script de gestion de télémétrie.  


## **Résultats obtenus : ce qui a fonctionné:**
- Application du script de télémétrie.
- GPO appliquées sur les ordinateurs et les utilisateurs.
- Règles de pare-feu adéquate au réseau.  

## **Améliorations possibles : suggestions d’améliorations futures:**  
- Affination des règles de pare-feu suivant l'évolution du réseau.  
- Approfondir la gestion de la télémétrie.  
