# TSSR : Projet 3 : Construction d’une infrastructure réseau

_Semaine6_  
_(Date de documentation 11 Décembre 2023)_
________


## **Besoins Initiaux:**

Réalisation d'une infrastructure sécurisé pour l'entreprise BillU. Un domaine AD a été installé et complété par un serveur de gestion de mot de passe pas encore opérationnel ainsi qu'un deuxième serveur DC avec réplication. Gestion automatique des salariés de la société dans le répertoire AD. Un serveur GLPI est en place ainsi qu'une dizaine de GPO. Des pare-feu PFSense sont installés sur les deux sitesLa télémérie des postes clients à été traitée. Pour compléter cette infrastructure, il a été demandé de commencer la stratégie de sauvegarde de certains dossiers et espace de stockage.
__________

## **Rôles par semaine:**

### Semaine 6 
| NOM | Rôles | Taches effectuées |
| :-- |:----- | :---------- |
| Valentin | Crew | Recherche et mise en place des sauvegardes des dossiers partagés |
| Jérôme  |  Product Owner | Gestion des HDD des machines, préparation et installation RAID1 |
| Bilal | Crew | Recherche et miss en place des sauvegarde des dossiers partagés |
| Michael | Scrum Master | Création des dossiers partagés individuels et services; Mise en place restriction horaire |
| Equipe | Workflow | Recheches : création des dossiers partagés et leurs sauvegardes. Recherche de laps. Restriction horaires miss en place |

__________


## **Objectifs principaux de la semaine:**

- Mettre en place des dossiers réseaux pour les utilisateurs avec sécurité de partage pour les dossiers individuels et dossiers de service. Dossiers individuels répertoriés sur le réseau en tant que lecteur "I" et dossiers de services en tant que lecteur "M".  
- Mettre en place un RAID 1 sur le volume système C : de l'AD de Paris.
- Mettre en place une sauvegarde au minimum une fois par semaine du volume contenant les dossiers partagés des utilisateurs dans un volume spécifique.

## **Objectifs secondaires de la semaine:**
- Créer une restriction horaire de connexion pour les utiisateurs non-admin domaine et local. La connexion sera autorisée de 7h30 à 20h du lundi au samedi.
- Mise en place de LAPS, installation sur l'AD de Paris et sur les postes clients par GPO
 
____________      


## **Choix Techniques:**

- Adapter un script pour la création des dossiers personnels.  
- Rajout d'un disque dur sur le serveur pour la mise en place du RAID 1 équivalent à la capacité de stockage du serveur.
- Rajout de deux disques dur de 40Go pour les dossiers partagés. Un lectuer "E" : pour le stockage des dossiers partagés, Et un lecteur "F" : pour la sauvegarde de ces dossiers.
- Utilisation de _**Windows Server Backup**_ pour la gestion de sauvegarde des dossiers partagés.
________________


## **Les difficultées rencontrées:** 


## **Les solutions:** 


## **FAQ:**
