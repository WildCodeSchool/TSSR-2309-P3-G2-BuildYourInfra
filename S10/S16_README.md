# TSSR : Projet 3 : Construction d’une infrastructure réseau

_Semaine10_  
_(Date de documentation 17 janvier 2024)_
________

## **Besoins Initiaux:**

Réalisation d'une infrastructure sécurisée pour l'entreprise BillU. Un domaine AD a été installé et complété par un serveur de gestion de mot de passe pas encore opérationnel ainsi qu'un deuxième serveur DC avec réplication. Gestion automatique des salariés de la société dans le répertoire AD. Un serveur GLPI est en place ainsi qu'une dizaine de GPO. Des pare-feu PFSense sont installés sur les deux sites. La télémérie des postes clients à été traitée. Pour compléter cette infrastructure, il a été réaliser la journalisation des scripts Powershell, 
installation du logiciel de supervision Zabbix et intégration des ordinateurs de l'entreprise à l'Active Directory. Un serveur de messagerie Zimbra à été installé ainsi qu'un serveur WSUS
gérant le déploiement des MAJ sur le Parc informatique. Pour compléter l'infrastructure, un serveur VoIP sera installé. 
_________
## **Rôles par semaine:**

### Semaine 10 
| NOM | Rôles | Taches effectuées |
| :-- |:----- | :---------- |
| Valentin | Product Owner | GLPI |
| Jérôme  | Agent Actif | IredMail |
| Bilal | Scrum Master | AD Core |
| Michael | Agent Actif | FreePBX, PRTG |
| Equipe |  | Remise en état des serveurs de l'infrastructure |

__________
## **Objectifs principaux de la semaine:**

Cette semaine les serveurs AD core, Zimbra, Zabbix et GLPI sont tombés en panne et irrécupérables. Remplacement du matériel défectueux par:
-2 serveurs DC en Windows CORE avec une configuration de stockage en RAID 1.
-1 Serveur GLPI sur Debian 11 en RAID 1 pour le stockage.
-IredMail remplace le serveur de messagerie Zimbra à la demande de l'entreprise.
-PRTG remplace le serveur de supervision Zabbix.
Un serveur VoiP sera installé dans l'infrastructure, en y créant des comptes AD et permettent les appels entre les ordinateurs de l'entreprise.
Les 5 rôles FSMO (Flexible Single Master Operation) seront répartis sur les 3 DC du parc.
Si possible, un serveur RODC sera installé sur Lyon.

___________

## **Choix Techniques:**

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
____________
## **Les difficultées rencontrées:** 

_____________

## **Les solutions:**

________________
## **FAQ:**
