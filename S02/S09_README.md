# TSSR : Projet 3 : Construction d’une infrastructure réseau

_Semaine2_  
_(Date de documentation 13 Novembre 2023)_
# Sommmaire

[1 : Besoin Initiaux :]()

[2 : Roles par Semaine :]()

[3 : Objectif semaine :]()

[4 : Choix techniques :]()

[5 : Difficultées rencontrées :]()

[6 : Solutions :]()


## Besoins Initiaux

BillU est une filiale du groupe international RemindMe, qui a plus de 10000 collaborateurs dans le monde.
L'infrastructure réseaux doit être adapté aux besoins de l'entreprise et sécurisé. Pour la Semaine_09 l'installation d'un serveur Active Directory.


##  Rôles par semaine

### Semaine 2 
| NOM | Roles | Taches éffectuées |
| :-- |:----- | :---------- |
| Valentin | Scrum Master | Recherche et script powershell pour enregistrer dans l'AD DS les salariés de l'entreprise. |
| Jerome  |  Product Owner | Réalisation de la structure AD, Configuration de la machine Proxmox|
| Bilal | Crew | Réalisation de la structure AD, rédaction des livrable de la semaine |
| Michael | Crew |Recherche et script powershell pour enregistrer dans l'AD DS les salariés de l'entreprise.|
| Equipe | Workflow | Prise en main de AD DS. Création d'un domaine AD DS. Renseigner base de données d'AD DS |

## Objectif semaine

Organiser une structure Active Directory et y intégrer les salariés de l'entreprise


##  Choix Techniques

Le Domaine AD aura pour nom BillU et sera structuré suivant les besoins de gestions.

##  Les difficultées rencontrées

- Le script d'enregistrement des utilisateurs n'a pas reconnu certains attribus de la liste
- Le script d'enregistrement des utilisateurs n'interprète pas les noms avec des espaces ou des caractères spéciaux tel que les accents ou les tirets. 

##  Les solutions 

- Adaptation du script d'enregistrement des utilisateurs afin d'utiliser la liste en csv avec les bons attributs
- Adaptation du script d'enregistrement des utilisateurs pour remplacer les caractères spéciaux par des lettres sans accents et les mots sans espaces.

