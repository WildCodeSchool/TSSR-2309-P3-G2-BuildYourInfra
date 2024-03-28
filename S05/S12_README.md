# TSSR : Projet 3 : Construction d’une infrastructure réseau

_Semaine5_  
_(Date de documentation 7 Decembre 2023)_

## Besoins Initiaux:

Réalisation d'une infrastructure sécurisé pour l'entreprise BillU. Un domaine AD a été installé et complété par un serveur de gestion de mot de passe pas encore opérationnel ainsi qu'un deuxième serveur DC avec réplication. Gestion automatique des salariés de la société dans le répertoire AD.
Un serveur GLPI a été mis en place afin de gérer le parc informatique et le ticketing pour la maintenance. Une dizaine de GPO a été créées dans l'AD.
Cette semaine un pare -feu PFSense a été installé sur chaque site, Paris et Lyon. La Télémétrie des postes Windows a été traitée. Un script appelé Télémétrie_Management a été créé afin de désactiver certains services de télémétrie présent sur les postes.


##  Rôles par semaine:

### Semaine 5:


| NOM | Rôles | Taches effectuées |
| :-- |:----- | :---------- |
| Valentin | Product Owner | Tests GPO, Github, Recherche Télémétrie, Règles de pare-feu |
| Jérôme  |  Crew |Tests GPO, Github, Installation PfSense,Test règles de pare-feu |
| Bilal | Scrum Master | Script Télémétrie, Github, Installation PfSense|
| Michael | Crew | Script Télémétrie, Tests GPO, Github, Test firewall |
| Equipe | Workflow | Installation et configuration PFSense, prise en main du Firewall, Les GPO, recherches Télémétries. |

## Objectif semaine:

- Prise en main PFSense et mise en application des 1eres Regles de Parefeu
- Creation script gestion Télémétrie
- Execution du Script Via GPO

##  Choix Techniques:

Les pare-feus sont des PFSense fournis par le DSI de l'entreprise BillU.
La Télémétrie est gérée par un script appliqué pae une GPO sur les ordinateurs afin de faciliter l'évolution de la gestion de cette télémétrie.

##  Les difficultés rencontrées

1. PFSense, PING persistant (proxmox).
2. Application du script de télémétrie en partage sur les ordinateurs de l'AD.

##  Les solutions 
1. Installation d'un nouveau PFSENSE.
2. Le script partagé est placé dans le dossier Syslog.
