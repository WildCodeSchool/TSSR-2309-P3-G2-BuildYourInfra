# User-guid BillU 
### _Semaine_S4_
### TSSR-Projet3-Groupe_2-BuildYourInfra


# **GLPI**

### **_Présentation_**:
______

GLPI permet d'avoir un état du parc informatique de façon dynamique et automatique grâce à l'ajout de l'agent GLPI.  
GLPI vous permet également de signaler un prblème avec un Utilisateur ou un appareil du parc.  
Ce manuel renseigne la procédure afin de déclarer au service informatique un incident avec le système de ticketing, qui permet de prioritariser les dépannages, les référencer et les archiver.

### **_Pré-requis_**:
________

Connaitre votre login Active Directory du domaine BillU.  
Le compte utilisateur doit faire partie du domaine BillU et avoir été connecter au minimum une fois.  
Faire la demande depuis un ordinateur intégrer au domaine BillU avec un accès à une page web et une adresse IP bien configuré dans la plage de réseaux du domaine.  

### **_Utilisation_**:
________

Pour déclarer un incident et générer un ticket d'intervention:
- Ouvrir une page web et dans la barre de recherche rentrer: **http://172.18.1.50/glpi**  
- Rentrer dans la page de connection votre identifiant et mot de passe de connection à votre session du domaine BillU.  
- Sélectionner **SRVWIN01** dans source de recherche et valider.  
- Remplir les champs de renseignements et être le plus précis possible dans la description afin d'aiguiller au mieux l'assistant dépanneur.  
- Quand tout est bien renseigner appuyer sur ajouter.  
- Un ticket vous sera attibuer et servira de suivi à l'incident.  



### _**FAQ**_:
________

| **Problèmes** | **Solutions** |
|-----|--------|
| Connection à la page web impossible | Contrôler que l'ordinateur a bien une adresse IP correct. |
| Erreur de connection à GLPI | Vérifier bien le mot de passe, le login doit se faire sous forme 1ère lettre prénom.nom (p.nom) |
| Erreur de connection à GLPI | Contrôler la source de recherche comme étant SRVWIN01|
| Erreur de connection à GLPI | Le compte utilisateur n'a pas eu une 1ère connection au domaine.|
