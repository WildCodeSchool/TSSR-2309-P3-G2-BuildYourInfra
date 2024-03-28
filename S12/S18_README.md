# TSSR : Projet 3 : Construction d’une infrastructure réseau

_Semaine12_  
_(Date de documentation 31 janvier 2024)_
________

## **Besoins Initiaux:**

Réalisation d'une infrastructure sécurisée pour l'entreprise BillU. Un domaine AD a été installé et complété par un serveur de gestion de mot de passe pas encore opérationnel ainsi qu'un deuxième serveur DC avec réplication. Gestion automatique des salariés de la société dans le répertoire AD. Un serveur GLPI est en place ainsi qu'une dizaine de GPO. Des pare-feu PFSense sont installés sur les deux sites. La télémérie des postes clients à été traitée. Pour compléter cette infrastructure, il a été réaliser la journalisation des scripts Powershell, 
installation du logiciel de supervision Zabbix et intégration des ordinateurs de l'entreprise à l'Active Directory. Un serveur de messagerie Zimbra à été installé ainsi qu'un serveur WSUS
gérant le déploiement des MAJ sur le Parc informatique. Pour compléter l'infrastructure, un serveur VoIP a été installé. Afin de sécuriser l'AD, un audit a été réalisé, et des corrections apportées suivant le résultat des analyses des outils d'audits.
Dans la continuité de sécurisation du réseau, un système NIDS est déployé est tests d'intrusion avec différent outils seront faits.

_________
## **Rôles par semaine:**

### Semaine 12 
| NOM | Rôles | Taches effectuées |
| :-- |:----- | :---------- |
| Valentin | Scrum Master | Réalisation des tableaux de synthèse. Configuration et test de l'agent NIDS Snort |
| Jérôme  | Crew | Installation des machines machines Snort et Kali. Test des outils Kali |
| Bilal | Product Owner | Prise en main de la machine Kali, test des outils d'intrusion |
| Michael | Crew | Test des outils Kali. Installation et configuration de Snort |
| Equipe |  | Prise en main de l'OS Kali Linux et de ses outils d'intrusion, ainsi que du NIDS Snort |

__________
## **Objectifs principaux de la semaine:**
1. Installation et utilisation d'un IDS/IPS Snort.
2. Effectuer des attaques à partir d'une machine Kali vers des éléments de l'infrastructure réseau.
3. Configurer Snort afin de détecter les attaques.
4. Réaliser un schéma d'infrastructure.
5. Réaliser de synthèse des machines, logiciels et documentation de l'infrastructure.

___________

## **Choix Techniques:**
**Snort** est installé sur le réseau en NIDS comme comme système de détection d'introduction.   
**Kali Linux** est utilisé afin de réaliser les différent tests d'intrusion sur les machines ou le réseau.  
**Nmap** est l'outil utilisé afin de réaliser l'attaque _Scan de ports_.  
**Medusa** est utilisé pour l'_Attaque force brute_ sur un serveur Debian.  


___________________

## **Les difficultées rencontrées:** 

_____________

## **Les solutions:**

________________
## **FAQ:**
