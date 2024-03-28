#Création du fichier ADUsers avant le lancement du script.






. ".\Library_Function.ps1"




##########################################################
####################  INITIALISATION  #################### 
##########################################################


$path1 = "C:\Users\Administrator\Desktop\s09_SocieteBillU.xlsx_-_Sheet1.csv"
$path2 = "C:\Users\Administrator\Desktop\s10_SocieteBillU.xlsx_-_Sheet1_1.csv"
$nameordi = $env:COMPUTERNAME
$File = "C:\Users\administrator\desktop\BillU.csv"
$domainName = "billu.lan"
$domainName1 = "DC=billu,DC=lan"
$ouUsers = "Utilisateurs"
$ouComputers = "Ordinateurs"
$ouSecurite = "Securite"
$ouDisableUser = "UtilisateursDesactive"
$ouDisableComputer = "MachinesDesactive"
$LogFile = "C:\Windows\logs\Log.log"
#Création OUPrestataire
$domainName2 = "Ou=Prestataires,DC=billu,DC=lan"
$ouPrestataires = "Prestataires"
$ouImagyne = "I-magyne"
$ouLivington = "Livingston&Associes"
$ouDlight = "StudioDlight"
$ouUbi = "UBIHard"
$domainName3 = "OU=I-magyne,Ou=Prestataires,DC=billu,DC=lan"
$domainName4 = "OU=Livingston&Associes,Ou=Prestataires,DC=billu,DC=lan"
$domainName5 = "OU=StudioDlight,Ou=Prestataires,DC=billu,DC=lan"
$domainName6 = "OU=UBIHard,Ou=Prestataires,DC=billu,DC=lan"
$domainName7 = "OU=DptCommunicationEtRelationsPubliques,OU=I-magyne,Ou=Prestataires,DC=billu,DC=lan"
$domainName8 = "OU=DptCommunicationEtRelationsPubliques,OU=StudioDlight,Ou=Prestataires,DC=billu,DC=lan"
$domainName9 = "OU=DptDeveloppementLogiciel,OU=UBIHard,Ou=Prestataires,DC=billu,DC=lan"
$domainName10 = "OU=DptJuridique,OU=Livingston&Associes,Ou=Prestataires,DC=billu,DC=lan" 
$ouDptComm = "DptCommunicationEtRelationsPubliques"
$ouDptJuridique = "DptJuridique"
$ouDptLogiciel = "DptDeveloppementLogiciel"
$ouRelationMedia = "RelationMedias"
$ouTests = "TestEtQualite"
$ouDroits = "DroitDesSocietes"


################################################
####################  MAIN  #################### 
################################################



Clear-Host

Log -FilePath $LogFile -Content "---------------- Debut du script ----------------" -BackgroundColor Green -ForegroundColor Black

CreateOUPrestataires; ModifAD_S14

Log -FilePath $LogFile -Content "------------------ Fin du script ----------------" -BackgroundColor Green  -ForegroundColor red
Log -FilePath $LogFile -Content "================================================="