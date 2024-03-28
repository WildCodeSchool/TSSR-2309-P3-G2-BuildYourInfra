
# **INSTALL GUIDE Infrastructure sécurisée pour BillU**
## _Semaine_09_


## **Besoins initiaux : besoins du projet**

BillU est une filiale du groupe international RemindMe, qui a plus de 10000 collaborateurs dans le monde.  
L'infrastructure réseaux doit être adapté aux besoins de l'entreprise et sécurisé.
Pour la Semaine_09 l'installation d'un serveur Active Directory.



## **Choix techniques**

Suite à nos observations du réseaux informatique de l'entreprise BillU, il a été relevé des risque de sécuritée.
Active Directory sera sous le Domaine BillU et sera organisé avec les Organization Unit suivant l'organisation nécessaire à sa gestion.   


## **Étapes d'installation et de configuration : instruction étape par étape**

- Nommer la machine qui servira au serveur Active Directory: G2-SRVWIN1 sera celui de BillU
- Installer Active Directory
- Création du domaine BillU
- Création de l’arborescence
- Implantation automatique des utilisateurs de l'entreprise suivant la liste fourni par le DSI. 



 
## **Difficultés rencontrées : problèmes techniques rencontrés**

- Le script d'enregistrement des utilisateurs n'a pas reconnu certains attribus de la liste
- Le script d'enregistrement des utilisateurs n'interprète pas les noms avec des espaces ou des caractères spéciaux tel que les accents ou les tirets.




## **Solutions trouvées : Solutions et alternatives trouvées**

- Adaptation du script d'enregistrement des utilisateurs afin d'utiliser la liste en csv avec les bons attributs
- Adaptation du script d'enregistrement des utilisateurs pour remplacer les caractères spéciaux par des lettres sans accents et les mots sans espaces.

## **Tests réalisés : description des tests de performance, de sécurité, etc.**

- Tests du script d'enregistrement des utilisateurs dans un domaine AD simulant celui de l'entreprise BillU. 
- Tests de différentes arborescence Active Directory du domaine BillU

## **Résultats obtenus : ce qui a fonctionné**

- Le script enregistre bien les utilisateurs dans les OU correspondant à leur emplacement dans l’arborescence.
- L'arborescence retenu pour BillU, correspond aux besoins d'ergonomie et de gestion de sécurité.
- Les sous Organization Units sont créés par le script automatiquement

## **Améliorations possibles : suggestions d’améliorations futures**
- Réalisation des Organization Unit principales par un script à tester
- Réunir les différents scripts en un seul
- Intégrer la journalisation des créations des utilisateurs AD ou OU
