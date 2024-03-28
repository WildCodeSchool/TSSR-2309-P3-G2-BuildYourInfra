# TSSR : Projet 3 : Construction d’une infrastructure réseau

_Semaine7_  
_(Date de documentation 18 Décembre 2023)_
________


## **Besoins Initiaux:**

Réalisation d'une infrastructure sécurisé pour l'entreprise BillU. Un domaine AD a été installé et complété par un serveur de gestion de mot de passe pas encore opérationnel ainsi qu'un deuxième serveur DC avec réplication. Gestion automatique des salariés de la société dans le répertoire AD. Un serveur GLPI est en place ainsi qu'une dizaine de GPO. Des pare-feu PFSense sont installés sur les deux sitesLa télémérie des postes clients à été traitée. Pour compléter cette infrastructure, il a été demandé de journaliser les scripts Powershell, installer  le logicie de supervision Zabbix et d'intégrer les ordinateurs à l'Active Directory.
_________
## **Rôles par semaine:**

### Semaine 7 
| NOM | Rôles | Taches effectuées |
| :-- |:----- | :---------- |
| Valentin | Scrum Master | Journalisation des scripts, intégration des ordinateurs à l'AD |
| Jérôme  | Crew | Installation de Zabbix et agent Zabbix |
| Bilal | Product Owner | Journalisation des scripts, gestion du csv de la semaine |
| Michael | Crew | Journalisation des scripts, gestion du csv de la semaine, installation de Zabbix |
| Equipe |  | Recherche Zabbix, réflexion de l'organisatiion des OU ordinateurs. |

__________

## **Objectifs principaux de la semaine:**

- Mettre en place une journalisation des scripts PowerShell
	- Utiliser le dossier `C:\Windows\logs`
	- Un seul log sera utilisé par script
	- On trouvera dans chaque fichier de log les informations sous la forme `YYYYMMDD-HHMMSS-<Utilisateur>-<Thématique>-<Information>
 
- Mise en place du logiciel de supervision ZABBIX
	- Installation sur un serveur
	- Supervision de l'ensemble des serveurs de l'infrastructure

- Intégration des ordinateurs
	- Intégration des PC du fichier XLSX dans l'AD
	- Faire les MAJ correspondantes aux modifications du fichier fourni en annexe
____________      


## **Choix Techniques:**

- Utilisation d'une fonction commune pour la journalisation appelée Log.
- Adaptation du script afin de gérer l'arrivée des machines de l'entreprise, des départs et arrivées des salariés et des prestataires.  
________________


## **Les difficultées rencontrées:** 


## **Les solutions:** 


## **FAQ:**
