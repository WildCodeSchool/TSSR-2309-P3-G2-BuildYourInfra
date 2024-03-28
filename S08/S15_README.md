# TSSR : Projet 3 : Construction d’une infrastructure réseau

_Semaine8_  
_(Date de documentation 03 janvier 2024)_
________


## **Besoins Initiaux:**

Réalisation d'une infrastructure sécurisée pour l'entreprise BillU. Un domaine AD a été installé et complété par un serveur de gestion de mot de passe pas encore opérationnel ainsi qu'un deuxième serveur DC avec réplication. Gestion automatique des salariés de la société dans le répertoire AD. Un serveur GLPI est en place ainsi qu'une dizaine de GPO. Des pare-feu PFSense sont installés sur les deux sites. La télémérie des postes clients à été traitée. Pour compléter cette infrastructure, il a été demandé de journaliser les scripts Powershell, installer le logiciel de supervision Zabbix et d'intégrer les ordinateurs à l'Active Directory. Mise en Place d'un serveur de messagerie Zimbra qui pourra nous aider a finir le serveur de gestionnaire de mot de passe et d'un serveur WSUS qui lui gérera le développement des MAJ sur le Parc informatique. 
_________
## **Rôles par semaine:**

### Semaine 8 
| NOM | Rôles | Taches effectuées |
| :-- |:----- | :---------- |
| Valentin | Crew |  Mise en place, installation et configuration du serveur WSUS|
| Jérôme  | Scrum Master | Mise en place, installation et configuration du serveur Zimbra |
| Bilal | Crew | Mise en place, installation et configuration du serveur WSUS |
| Michael | Product Owner | Mise en place, installation et configuration du serveur Zimbra |
| Equipe |  | Recherche et mise en place des serveurs en lab et sur Proxmox, édition des livrables, Préparation Canva et Demo tech |

__________

## **Objectifs principaux de la semaine:**

- Mettre en place un serveur de messagerie zimbra
	- Création de compte mail lié aux Utilisateurs AD
	- Connection a la boite mail par LAN uniquement pour l'instant

 
- Mise en place d un serveur WSUS
	- Gestion des mises à jour via le serveur 
	- Détection des machines du parc

- Création d'un schéma de l'infrastructure du Parc
____________      


## **Choix Techniques:**

- Serveur de messagerie Zimbra imposé. installation de la version 8.8.15 car à partir la version 9 le logiciel est payant. le serveur sera installé sur la dernière version de Ubuntu gérée soit la 18.04
- Installation d'un nouveau serveur win22 pour l'installation du role WSUS  
________________


## **Les difficultées rencontrées:** 

- la mise en place des GPO a demandé d'importer les paramètres manquants des paquets admx et adml à placer dans le fichier SYSVOL 

## **Les solutions:** 

- Créer notre propre Administrative Template afin d'avoir les options nécessaires à la création des GPO souhaitées.

## **FAQ:**
