# TSSR : Projet 3 : Construction d’une infrastructure réseau

_Semaine3_  
_(Date de documentation 20 Novembre 2023)_
# Sommmaire

[1 : Besoin Initiaux :]()

[2 : Roles par Semaine :]()

[3 : Objectif semaine :]()

[4 : Choix techniques :]()

[5 : Difficultées rencontrées :]()

[6 : Solutions :]()


## Besoins Initiaux

Réalisation d'une infrastructure sécurisé pour l'entreprise BillU. Un domaine AD a été installé et sera complété par un serveur de gestion de mot de passe et un deuxième serveur DC
avec réplication.


##  Rôles par semaine

### Semaine 3 
| NOM | Rôles | Taches effectuées |
| :-- |:----- | :---------- |
| Valentin | Crew | Configuration connexion SSH client-serveur. Configuration du serveur Core |
| Jérôme  |  Crew | Installation et configuration du serveur Bitwarden et du serveur Core|
| Bilal | Product Owner | Scripting PowerShell|
| Michael | Scrum Master | Scripting PowerShell|
| Equipe | Workflow | Recherche de la configuration et intégration du serveur Core en DC dans le domaine. Recherche Bitwarden|

## Objectif semaine

Les objectifs de la semaine sont:
- Création d'un serveur Windows Core 2022. Il sera intégrer au domaine BillU en tant que DC et la réplication devra être opérationnel.
- Installer et configurer un serveur Bitwarden pour la gestion de mot de passe. Ce serveur aura un compte Utilisateur afin de se pouvoir se connecter en SSH depuis un poste client.
- Un client devra être intégrer au domaine BillU et sera en mesure de se connecter au serveur Bitwarden.
- Le script d'automatisation permettra la création automatique des groupes AD, des OU et la désactivation des utilisateurs. Il traitera la mise à jour des fichier salariés transmis par le service RH de l'entreprise BillU



##  Choix Techniques

Utilisation de Windows Server 2022 pour le DC supplémentaire. 
Utilisation de Debian LXC pour l'application Bitwarden afin gérer les mots de passe. 


##  Les difficultés rencontrées

Utilisation de Bitwarden, difficultés à se connecter au serveur en graphique.
Difficultés à connecter le serveur Core au domaine en tant que DC
Adapter le script 


##  Les solutions 




