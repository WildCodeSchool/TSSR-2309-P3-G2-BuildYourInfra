# **INSTALL GUIDE Infrastructure sécurisée pour BillU**
## _Semaine_S6_
_Date de documentation: 11/12/2023_
__________

## **Besoins initiaux : besoins du projet:**

Réalisation d'une infrastructure sécurisé pour l'entreprise BillU. Un domaine AD a été installé et complété par un serveur de gestion de mot de passe pas encore opérationnel ainsi qu'un deuxième serveur DC avec réplication. Gestion automatique des salariés de la société dans le répertoire AD. Un serveur GLPI est en place ainsi qu'une dizaine de GPO. Des pare-feu PFSense sont installés sur les deux sitesLa télémérie des postes clients à été traitée. Pour compléter cette infrastructure, il a été demandé de commencer la stratégie de sauvegarde de certains dossiers et espace de stockage.
________________
## **Choix techniques:**
- Adapter un script pour la création des dossiers personnels.
- Rajout d'un disque dur sur le serveur pour la mise en place du RAID 1 équivalent à la capacité de stockage du serveur.
- Rajout de deux disques dur de 40Go pour les dossiers partagés. Un lectuer "E" : pour le stockage des dossiers partagés, Et un lecteur "F" : pour la sauvegarde de ces dossiers.
- Utilisation de Windows Server Backup pour la gestion de sauvegarde des dossiers partagés. Les sauvegardes sont programmées tout les jours à 23h afin que le serveur et les dossiers soit le moins sollicité possible lors des sauvegardes.  

_______________
# **Étapes d'installation et de configuration : instruction étape par étape:**


## Mise en place du RAID 1 sur le volume systeme de l'AD PARIS

Ajouter un nouveau disque dur **(taille minimal equivalente a celle du disque systeme)** au serveur afin de mettre en place le systeme RAID 1.

Puis démarrer le serveur, aller sur _computer manager_, le nouveau disque devrait être visible.

Faire un clic droit sur le disque système et le mettre en mode dynamique. Faire de même sur le deuxième disque. 

Une fois les deux disques en mode dynamique, faire un clic droit sur le disque système et faire "_add mirror_" puis lui indiquer le deuxième disque pour le miroir.

Les disques sont dorénavant en mode : _mirrored volumed_ et se synchronisent.

![img](https://github.com/michaelc31/Projet-image/blob/main/Nouveau%20dossier/RAID.JPG?raw=true)

## Mettre en place des dossiers réseaux pour les utilisateurs

## Dossier individuel.

Pré-requis: Les dossiers personnels sont stockés sur un nouveau disque dur ajouté à notre serveur AD dans lequel est créé un dossier partagé "PersonnalFolders" qui acceuillera l'ensemble des dossiers personnels.  

![personnalFolders](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/assets/146104077/36fd57ae-463c-4478-8df8-13bd907f74e1)


Afin de créer et partager via le reseau le dossier personnel de chaque utilisateur, le profil utilisateur dans l'AD est modifié dans le champs : "Home folder" en faisant un clic droit sur l'utilisateur et aller sur propriétés :

connect I: to \\SRVWIN1\PersonnalFolders\%username%  

_%username% represente le nom de l utilisateur AD_  

![img](https://github.com/michaelc31/Projet-image/blob/main/Nouveau%20dossier/DP.JPG?raw=true)


Pour nos besoins nous avons plus de 100 utilisateurs AD, nous passerons par un script qui modifiera les données sur les utilisateurs AD en ajoutant le chemin pour le dossier partagé. 

Les tests révèlent que le champs se rempli correctement mais ne crée pas le dossier partagé. Il a été rajouté au script à la création des dossiers personnels manuellement.

    Commande utiliser :

        $users = Get-ADUser -filter *

        foreach ($user in $users)
        {
        $cheminDossierPartage = "\\SRVWIN\PersonnalFolders\$($user.SamAccountName)"
            Set-ADUser $user -HomeDirectory $cheminDossierPartage -HomeDrive "I:"
            New-Item $cheminDossierPartage -ItemType Directory 
            Write-Host "le dossier personnel à été crée et à été ajouté au lecteur logique I:" -ForegroundColor Green 
        }

Après des tests sur différents clients windows 10 le dossier créé par le script est bien un dossier nominatif et placé sur I:

![img](https://github.com/michaelc31/Projet-image/blob/main/Nouveau%20dossier/Dp2.JPG?raw=true)

________________
## Dossier Service.

Pré-requis : création manuelle de l'ensemble des dossiers partagés de départements et services dans un dossier nommé "DptFolders" sur le nouveau disque dur implanté dans notre serveur AD dans lequel sont déjà stockés les dossiers personnels. (voir exemple)

![img](https://github.com/michaelc31/Projet-image/blob/main/Nouveau%20dossier/DS.JPG?raw=true)

Le dossier DptCommercial contient les dossiers de chaque service (voir exemple)

![img](https://github.com/michaelc31/Projet-image/blob/main/Nouveau%20dossier/DS2.JPG?raw=true)

A la suite de cette opération il est nécessaire d'attribuer les droits spécifiques au groupe AD pour accéder à son propre dossier de service et/ou département. 
Exemple de traitement avec le département Juridique ci-dessous :

Partage du dossier "DptJuridique" en ajoutant le groupe Dptjurique en mode lecture uniquement.

![dptjuridique1](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/assets/146104077/d03bbc9a-23a9-4846-b5d4-867083710bdf)

![dptjuridique2](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/assets/146104077/bb249e86-a73d-4f96-81e5-297766042c49)

Dans le dossier "DptJuridique" se trouve deux autres dossiers "ProtectionIntellectuelle" et "ProtesctionDesDonneesEtConformite"

![img](https://github.com/michaelc31/Projet-image/blob/main/Nouveau%20dossier/DS5.JPG?raw=true)

Partage du dossier "ProtectionIntellectuelle" en ajoutant le groupe ProtectionIntellectuelle et en désactivant les droits héréditaires du dossier "DPTjuridique". 
Faire de même avec le dossier "ProtesctionDesDonneesEtConformite" en ajoutant le bon groupe.

![img](https://github.com/michaelc31/Projet-image/blob/main/Nouveau%20dossier/DS6.JPG?raw=true)

![img](https://github.com/michaelc31/Projet-image/blob/main/Nouveau%20dossier/DS7.JPG?raw=true)

Tests réalisés en se connectant avec les utilisateurs de l'AD suivants : h.cault et y.boye. Chaque utilisateur de l'AD ne voit que le dossier de son service.

![img](https://github.com/michaelc31/Projet-image/blob/main/Nouveau%20dossier%20(2)/Capture2.JPG?raw=true)

![img](https://github.com/michaelc31/Projet-image/blob/main/Nouveau%20dossier%20(2)/Capture3.JPG?raw=true)
_____________________

### Preparation des GPO pour mapper les dossiers de service 

Les GPO devront etre créé pour chaque Departement afin de structurer les access au droit des dossier.

ouvrir Group Policy Manager créé une nouvelle GPO : dans notre cas on l'appelera USER_AcessFolder_DPT* (* = le departement choisi) on va faire les reglage de base ajoute le GRP_computer et le Groupe Utilisateur AD voulu, on va desactiver la parti computer de la GPO 

![img](https://github.com/michaelc31/Projet-image/blob/main/Nouveau%20dossier%20(2)/Capture10.JPG?raw=true)

![img](https://github.com/michaelc31/Projet-image/blob/main/Nouveau%20dossier%20(2)/Capture11.JPG?raw=true)

Ceci fait, Editer la GPO afin de pouvoir Mapper le dossier voulu.

Aller dans `User configuration / Preferences / Windows Settings / Drive Maps` et faite clique droit New 

![img](https://github.com/michaelc31/Projet-image/blob/main/Nouveau%20dossier%20(2)/Capture12.JPG?raw=true)

ajouter la localisation, et un label afin de le Nommé selectionne la lettre de mappage et appliquer

![img](https://github.com/michaelc31/Projet-image/blob/main/Nouveau%20dossier%20(2)/Capture13.JPG?raw=true)

appliquer la GPO sur l'OU voulu est faites un test avec un client connecter a l'AD est verifier que le dossier de Service est bien accessible.

![img](https://github.com/michaelc31/Projet-image/blob/main/Nouveau%20dossier%20(2)/Capture14.JPG?raw=true)
 
![img](https://github.com/michaelc31/Projet-image/blob/main/Nouveau%20dossier%20(2)/Capture15.JPG?raw=true)
_______________
_______________

# RESTRICTION D'UTILISATION DES MACHINES - restriction horaire

Pour cet objectif deux actions à réaliser :

**Premierement** : régler la plage horaire pour chaque utilisateur dans l'AD, action effectuée par commande powershell :

`Get-ADUser -SearchBase "OU=Utilisateurs,DC=billu,DC=lan" -Filter *| Set-LogonHours -TimeIn24Format @(7,8,9,10,11,12,13,14,15,16,17,18,19,20) -Monday -Tuesday -Wednesday -Thursday -Friday -Saturday -NonSelectedDaysare NonWorkingDays`

Cette commande permet de modifier la plage horaire de connection de tous les utilisateurs AD du lundi au samedi de 7h a 20h. 
Modification du tableau comme indiqué ci-dessous.

![img](https://github.com/michaelc31/Projet-image/blob/main/Nouveau%20dossier%20(2)/Capture4.JPG?raw=true)

Pour tous les administrateurs AD modification manuelle afin qu'ils ne soient pas affectés par la GPO qui sera créé et qu'ils n'aient pas de restriction horaire.

**Deuxiemement** : Créer une GPO Ordinateur qui va déconnecter et empecher la connection en dehors de la plage horaire attribuée.

Création : dans Group Policy Management -> nouvelle GPO -> nommée "COMPUTER_Restriction" qui sera appliquée sur l'OU ordinateur, et on s'assure que GPO Status soit bien "User configuration settings disabled".

Edition de la GPO : 

![img](https://github.com/michaelc31/Projet-image/blob/main/Nouveau%20dossier/RU2.JPG?raw=true)

Dans le chemin "Computer configuration / Policies / Windows Settings / Security Settings / Local Policies / Security Option" sélectionner "Microsoft network server: Disconnect Client when Logon Hours Expire" et l'activer "Enabled",valider puis appliquer la GPO.

Pour les tests, réglage de l'heure pour un utilisateur AD afin qu'il ne puisse pas se connecter peu importe l'heure et un autre utilistauer AD qui accède à sa cession jusqu'a 20h.

le premier utilisateur ne peut se connecter alors que le deuxieme le peut.

![img](https://github.com/michaelc31/Projet-image/blob/main/Nouveau%20dossier/RU3.JPG?raw=true)
______________
______________

# Installation et configuration du service de sauvegarde _Windows Server Backup_:  
> Cette notice permet la configuration du service de sauvegarde planifiée pour les dossiers partagés du volume E: vers le volume F:.  
> La sauvegarde ponctuel est possible en choisissant _Backup simple_ au lieu de _Backup Schedule_ dans le menu.

- Le volume E: _SharedFolders_ contient les dossiers à sauvegarder vers le volume F: _ShareFoldersBackup_.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/TutoSauvegarde/1.Disk_Manager.png?raw=true)
___________________

- Aller dans _Server Manager_.  
- Cliquer sur _Add roles and features_.  
- Cliquer 2 fois sur _NEXT_, sélectionner le serveur s'il ne l'ai pas, puis 2 fois _NEXT_.
- Cocher le service _Windows Server Backup_. Cliquer ensuite sur _NEXT_.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/TutoSauvegarde/3.Select_features.png?raw=true)
________________

- Cliquer sur _Install_ à l'écran de confirmation.
- Une fois l'installation terminée, cliquer sur _Close_.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/TutoSauvegarde/4.End_install.png?raw=true)
______________

- Dans _Server Manager_, cliquer sur _TOOLS_ puis _Windows Server Backup_.
- Cliquer sur _Local Backup_ dans la colonne de gauche de la fenêtre.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/TutoSauvegarde/2.Local_Backup.png?raw=true)
____________

- Dans la colonne de droite cliquer sur _Backup Schedule_ puis sélectionner le serveur dans la fenêtre de début puis _NEXT_.
- Sélectionner la configuration de sauvegarde en cochant _Custom_. L'autre option est pour sauvegarder tout le serveur.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/TutoSauvegarde/5.SelectBackup.png?raw=true)
____________

- Sélectionner l'objet de sauvegarde: Cliquer sur _Add Items_ et sélectionner le disque E:
- Cliquer _OK_ puis _NEXT_.  
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/TutoSauvegarde/6.SelectItem.png?raw=true)
___________

- Spécifier l'heure de sauvegarde avec le déroulant à côteé de _Once a day_ qui est coché. (_Il est possible de faire plusieurs sauvegarde par jour en cochant More than once a day, et d'ajouter les heures désirés dans le tableaux_)
- Cliquer _NEXT_.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/TutoSauvegarde/7.BackupTime.png?raw=true)
__________

- Spécifier le type de destination de sauvegardes. Cocher la première qui est _recommendée_. Cette option utilise le volume de destination exclusivement aux sauvegardes planifiées.
La deuxième est pour l'utilisation partiel d'un volume et la troisième pour un stockage partagé sur un réseau.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/TutoSauvegarde/8.DestinationType.png?raw=true)
__________

- Sélectionner le volume de stockage des sauvegardes. Cliquer sur _Show disks_ et cocher F: puis _OK_.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/TutoSauvegarde/9.DestinationDisk.png?raw=true)

- Une fenêtre d'avertissement s'ouvre, cliquer _Yes_. Elle met en garde qu'en validant ces configurations, le volume de destination sera utiisé exclusivement à la sauvegarde, ne pourra plus être utilisé pour d’autres tâches et ne sera plus visible dans l'explorateur de fichier.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/TutoSauvegarde/11.DestinationDisk.png?raw=true)
____________

- Cliquer sur _Finish_ à la fenêtre de confirmation.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/TutoSauvegarde/12.Confirmation.png?raw=true)
____________

- Si tout est bien installé, la fenêtre _Summary_ s'affiche avec un status de création avec succès de la sauvegarde.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/TutoSauvegarde/13.Close.png?raw=true)
_____________

- De retour sur la fenêtre de _Local Backup_, la sauvegarde programmée est affichée sous la colonne _Next Backup_.
![](https://github.com/Bilal-Aldimashq/TSSR-Projet3-Groupe_2-BuildYourInfra/blob/main/Resources/TutoSauvegarde/14.EndView.png?raw=true)
