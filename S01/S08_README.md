# TSSR : Projet 3 : Construction d’une infrastructure réseau

_(Date de documentation 08 Novembre 2023)_
# Sommmaire

[1 : Besoin Initiaux :]()

[2 : Roles par Semaine :]()

[3 : Objectif semaine :]()

[4 : Choix techniques :]()

[5 : Difficultées rencontrées :]()

[6 : Solutions :]()


## Besoins Initiaux

BillU est une filiale du groupe international RemindMe, qui a plus de 10000 collaborateurs dans le monde.
Elle est spécialisée dans le développement de logiciels, entre-autre de facturation.
Le groupe prévoit un budget conséquent pour développer cette filiale. Elle a 2 sites, l'un à Paris (20èm) et l'autre à Lyon
L'infrastructure réseaux doit être adapté aux besoins de l'entreprise et sécurisé.



##  Rôles par semaine

### Semaine 1 
| NOM | Roles | Taches éffectuées |
| :-- |:----- | :---------- |
| Valentin | Scrum Master | Organisation des Daily, mise en forme du plan d'adressage |
| Jerome  |  Product Owner | En contact avec le DSI. Création du support de présentation |
| Bilal | Crew | Plan d'adressage et renseigner les livrables de la semaine |
| Michael | Crew | Réalisation de la schématisation du réseau proposé |
| Equipe | Workflow |Prise de connaissance et réflexion de l'infrastructure réseau et système de l'entreprise. Proposition de solutions adaptées |

## Objectif semaine
Comprendre les axes d'amélioration à apporter sur le réseaux. Faire une proposition Sur les évolutions des services fonctionnels et du réseau.  
Fournir un plan d'adressage IP et un plan schématique du futur réseaux
  
##  Choix Techniques
Suite à l'analyse du réseaux informatique de l'entreprise BillU, il a été relevé des risque de sécuritée. Recommandation d'installation de serveurs afin de sécuriser et organiser le réseaux dans l'intérêt de l'organisation de l'entreprise.

##  Les difficultées rencontrées

Manque de sécuritée sur le réseau tel que  connexions sans mot de passe, messagerie en Cloud sur le Web,
pas de serveur d'administration et accès internet en wifi dans toute l'entreprise via des répétiteurs. Données sauvegardées sur un NAS grand public, sans rétention ni redondance. 

##  Les solutions 

Pour Sécuriser le réseaux des serveurs seront installés. Parmis ceux-là un serveur Active Directory pour la gestion sécurisée du domaine informatique. Une sécurité d'identité sera mise en place afin de péréniser les connexion au réseaux de l'entreprise. Le réseaux sera configuré afin d'apporter une connexion sécurisée, entre autre avec l'installation d'un Firewall. Un serveur DHCP et un serveur DNS, seront configurés afin de contrôler en interne la gestion du réseaux.
Un serveur de messagerie sécurisé sera installé afin de remplacer celui en cloud sur le web. Un serveur de stockage sera installé afin de sécuriser les données de l'entreprise et permettre une redondance de celles-ci et fiabiliser les sauvegardes. Afin que les deux sites puissent accéder aux serveurs suivant leur besoins, des routeurs et des VLAN seront installés sur le réseaux. Les VLAN permettront de sécuriser les bases de données en limitant leurs accès par services (Droits des différents services à définir par la direction de BillU)



