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

################################################
####################  MAIN  #################### 
################################################



Clear-Host

Log -FilePath $LogFile -Content "---------------- Debut du script ----------------" -BackgroundColor Green -ForegroundColor Black

#VerifAD ;

#CreateADForest ;

#Create1erOU ;

#FormatCsv ; CreateOUUtilisateur ; CreateOUOrdinateur ; Creategrp1

#FormatCsv ; DptSrv ; CreateSousOUUtilisateur ; CreateSousOUOrdinateur ; Creategrp2

FormatCsv ;# CreateUser ;

FormatCsv2 ; ModifAD ; 

rangement

Get-ADUser -SearchBase "OU=Utilisateurs,DC=billu,DC=lan" -Filter * | Set-LogonHours -TimeIn24Format @(7,8,9,10,11,12,13,14,15,16,17,18,19) `
                    -Monday -Tuesday -Wednesday -Thursday -Friday -Saturday -NonSelectedDaysare NonWorkingDays

Log -FilePath $LogFile -Content "------------------ Fin du script ----------------" -BackgroundColor Green  -ForegroundColor red
Log -FilePath $LogFile -Content "================================================="