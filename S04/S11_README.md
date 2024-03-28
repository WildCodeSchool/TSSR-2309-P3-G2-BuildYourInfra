# TSSR : Projet 3 : Construction d’une infrastructure réseau

_Semaine4_  
_(Date de documentation 27 Novembre 2023)_

## Besoins Initiaux
Réalisation d'une infrastructure sécurisé pour l'entreprise BillU. Un domaine AD a été installé et complété par un serveur de gestion de mot de passe pas encore opérationnel ainsi qu'un deuxième serveur DC avec réplication. Gestion automatique des salariés de la société dans le répertoire AD.


##  Rôles par semaine

### Semaine 4 
| NOM | Rôles | Taches effectuées |
| :-- |:----- | :---------- |
| Valentin | Crew | Création des GPO |
| Jérôme  |  Scrum Master | Configuration du serveur GLPI, Synchronistion des utilisateurs AD |
| Bilal | Crew | Installation et configuration du serveur GLPI |
| Michael | Product Owner | Configuration GLPI, Création des GPO |
| Equipe | Workflow | Recherche afin d'installer, configurer et utiliser GLPI. Recherche des GPO. |

## Objectif semaine

- Création d'une dizaine de GPO.  
- Créer un serveur GLPI et le synchroniser au domaine BillU.  
- Gérer le parc avec GLPI, comprenant les utilisateurs, ordinateurs et groupes.
- Mise en place d'un système ticketing avec GLPI, pour la gestiion des incidents.
- Automatiser la création de serveur core par script
- Revoir le script (Indentation et journalisation)

##  Choix Techniques
- Le serveur Glpi sera installé sur un OS Ubuntu Server 22.04 et gérer graphiquement par le serveur AD.
- Les GPO installées sont:  
1 - Politique de mot de passe : éxigé des mot de passe compliqué, qui auront une valider prédéfini.  
2 - Vérouillage de compte : bloque l'accès après plusieurs tentative de fraude.  
3 - Resteindre l'installation logiciel : Empêche l'installation aux utilisateur lambda.  
4 - Déploiement logiciel : Permet d'automatiser l'installation logiciel.  
5 - Windows update : Definir heure d'installation, delai avant installation.  
6 - Bloquer accès aux registres.  
7 - Moderer l'accès au panneaux de config.  
8 - Restreindre l'acces aux perifs amovible.  
9 - Créer un compte admin local sur les machines : définir un compte du domaine qui sera administrateur local des machines avec une GPO.  
10 - GPO ésthetique : (wallpaper fixe, raccourcies fixes, dossier partagé) 11 - Vérouilllage classique : Vérouillage session après un temps d'inutilité.  
12 - Gestion alimentation : PC portable.  
13 - Firewall : Désactiver les firewall le temps de pouvoir les configurés.  
14 - Mapper les lecteurs logique.  


##  Les difficultés rencontrées

- Utilisation GLPI.  

##  Les solutions 
