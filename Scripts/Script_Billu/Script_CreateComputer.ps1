. ".\Library_Function.ps1"


##########################################################
####################  INITIALISATION  #################### 
##########################################################

$path1 = "C:\Users\Administrator\Desktop\s09_SocieteBillU.xlsx_-_Sheet1.csv"
$path2 = "C:\Users\Administrator\Desktop\s10_SocieteBillU.xlsx_-_Sheet1_1.csv"
$path3 = "C:\Users\Administrator\Desktop\s14_SocieteBillU.xlsx_-_Sheet1.csv"
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

################################################
####################  MAIN  #################### 
################################################

Clear-Host

Log -FilePath $LogFile -Content "---------------- Debut du script ----------------" -BackgroundColor Green -ForegroundColor Black

FormatCsv3 ; CreateComputer

Log -FilePath $LogFile -Content "------------------ Fin du script ----------------" -BackgroundColor Green  -ForegroundColor red
Log -FilePath $LogFile -Content "================================================="