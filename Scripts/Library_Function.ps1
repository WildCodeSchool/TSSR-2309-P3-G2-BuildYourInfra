#regionFonction
####################################################
####################  FONCTION  #################### 
####################################################


Function VerifAD
{
    If (-not(Get-Module -Name activedirectory))
    {
        Import-Module activedirectory
    }
Log -FilePath $LogFile -Content "Création de l'Active Directory"

}

Function CreateADForest
{
    # Vérifier si le domaine existe déjà
    $domainExists = Get-ADDomain -Server $domainName -ErrorAction SilentlyContinue

    if ($domainExists) 
        {
            Write-Host "Le domaine $domainName existe déjà." -ForegroundColor Yellow -BackgroundColor Black
            Log -FilePath $LogFile -Content "NoCréation- Domaine $domainName déjà éxistant"
        } 
    else 
    {
        # Créer la nouvelle forêt
        Install-ADDSForest -DomainName $domainName -DomainMode Win2012R2 -ForestMode Win2012R2 -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -LogPath "C:\Windows\NTDS" -SysvolPath "C:\Windows\SYSVOL" -Force -Verbose
        Write-Host "Création du domaine $domainName" -ForegroundColor Green
        Log -FilePath $LogFile -Content "Création du domaine $domainName"
    }

}

function Log
{
    param([string]$FilePath,[string]$Content)

    # V�rifie si le fichier existe, sinon le cr�e
    If (-not (Test-Path -Path $LogFile))
    {
        New-Item -ItemType File -Path  $LogFile | Out-Null
    }

    # Construit la ligne de journal
    $Date = Get-Date -Format "dd/MM/yyyy-HH:mm:ss"
    $User = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
    $logLine = "$Date;$User;$Content"

    # Ajoute la ligne de journal au fichier
    Add-Content -Path $LogFile -Value $logLine
}

Function Create1erOU
{
    # Vérifier si les OUs existent déjà
    $ouUsersExists = Get-ADOrganizationalUnit -Filter "Name -eq '$ouUsers'" 
    $ouComputersExists = Get-ADOrganizationalUnit -Filter "Name -eq '$ouComputers'" 
    $ouSecuriteExists = Get-ADOrganizationalUnit -Filter "Name -eq '$ouSecurite'"
    $ouDisableUserExists = Get-ADOrganizationalUnit -Filter "Name -eq '$ouDisableUser'"
    $ouDisableComputerExists = Get-ADOrganizationalUnit -Filter "Name -eq '$ouDisableComputer'"
    # Créer les OUs s'ils n'existent pas
    if (-not $ouUsersExists) 
        {
            New-ADOrganizationalUnit -Name $ouUsers -Path "$domainName1"
            Write-Host "Création de l'OU OU=$ouUsers,DC=BillU,DC=lan" -ForegroundColor Green
            Log -FilePath $LogFile -Content "Création de l'OU OU=$ouUsers,DC=BillU,DC=lan"
        } 
    else 
        {
            Write-Host "L'OU $ouUsers existe déjà." -ForegroundColor Yellow -BackgroundColor Black
               Log -FilePath $LogFile -Content "NoCréation- OU $ouUsers déjà éxistant"
        }

    if (-not $ouComputersExists) 
        {
        New-ADOrganizationalUnit -Name $ouComputers -Path "$domainName1"
        Write-Host "Création de l'OU OU=$ouComputers,DC=BillU,DC=lan" -ForegroundColor Green
        Log -FilePath $LogFile -Content "Création de l'OU OU=$ouComputers,DC=BillU,DC=lan"
        } 
    else 
        {
        Write-Host "L'OU $ouComputers,DC=BillU,DC=lan existe déjà." -ForegroundColor Yellow -BackgroundColor Black
           Log -FilePath $LogFile -Content "NoCréation- OU $ouComputers déjà éxistant"
        }
    if (-not $ouSecuriteExists) 
        {
            New-ADOrganizationalUnit -Name $ouSecurite -Path "$domainName1"
            Write-Host "Création de l'OU OU=$ouSecurite,DC=BillU,DC=lan" -ForegroundColor Green
            Log -FilePath $LogFile -Content "Création de l'OU OU=$ouSecurite,DC=BillU,DC=lan"
        } 
    else 
        {
            Write-Host "L'OU $ouSecurite existe déjà." -ForegroundColor Yellow -BackgroundColor Black
               Log -FilePath $LogFile -Content "NoCréation- OU $ouSecurite déjà éxistant"
        }
    if (-not $ouDisableComputerExists) 
        {    
            New-ADOrganizationalUnit -Name $ouDisableComputer -Path "$domainName1"
            Write-Host "Création de l'OU OU=$ouDisableComputer,DC=BillU,DC=lan" -ForegroundColor Green
            Log -FilePath $LogFile -Content "Création de l'OU OU=$ouDisableComputer,DC=BillU,DC=lan"
        }     
    else 
        {
            Write-Host "L'OU $ouDisableComputer existe déjà." -ForegroundColor Yellow -BackgroundColor Black
               Log -FilePath $LogFile -Content "NoCréation- OU $ouDisableComputer déjà éxistant"
        }
    if (-not $ouDisableUserExists) 
        {
            New-ADOrganizationalUnit -Name $ouDisableUser -Path "$domainName1"
            Write-Host "Création de l'OU OU=$ouDisableUser,DC=BillU,DC=lan" -ForegroundColor Green
            Log -FilePath $LogFile -Content "Création de l'OU OU=$ouDisableUser,DC=BillU,DC=lan"
        } 
    else 
        {
            Write-Host "L'OU $ouDisableUser existe déjà." -ForegroundColor Yellow -BackgroundColor Black
               Log -FilePath $LogFile -Content "NoCréation- OU $ouDisableUser déjà éxistant"
        }
}

Function FormatCsv
{
    NormalizeCsv ; RemplaceMot
}

Function NormalizeCsv 
{
    # Importer le fichier CSV initial
    $Users = Import-Csv -Path $path1
    # Parcourir chaque ligne et chaque colonne pour supprimer les accents et les espaces
    foreach ($row in $Users) 
    {
        foreach ($property in $row.PSObject.Properties) 
        {
            # Supprimer les accents
            $property.Value = $property.Value.Normalize('FormD') -replace '[^\p{IsBasicLatin}]', ''
            # Supprimer les espaces
            $property.Value = $property.Value.Replace(' ', '')
        }
    }

    # Exporter les données dans un nouveau fichier CSV
    $Users | Export-Csv -Path 'C:\Users\Administrator\Desktop\BillU.csv' -NoTypeInformation
}

Function RemplaceMot
{
    (Get-Content -Path 'C:\users\Administrator\Desktop\BillU.csv') `
                    -replace 'servicerecrutement','DptRecrutement' -replace 'servicecommercial','DptCommercial' `
                    -replace 'FinanceetComptabilite','DptFinanceEtComptabilite' -replace 'QHSE','DptQHSE' `
                    -replace 'ServiceJuridique','DptJuridique' -replace 'Direction','DptDirection' `
                    -replace 'Developpementlogiciel','DptDeveloppementLogiciel' `
                    -replace 'CommunicationetRelationspubliques','DptCommunicationEtRelationsPubliques' `
                    -replace 'DSI','DptDSI' -replace 'Communicationinterne','CommunicationInterne' -replace 'Gestiondesmarques','GestionDesMarques' `
                    -replace 'Testetqualite','TestEtQualite' `
                    -replace 'analyseetconception','AnalyseEtConception' `
                    -replace 'AdministrationSystemesetReseaux','AdministrationSystemesEtReseaux' `
                    -replace 'DeveloppementetIntegration','DeveloppementEtIntegration' `
                    -replace 'RechercheetPrototype','RechercheEtPrototype' `
                    -replace 'Gestionenvironnementale','GestionEnvironnementale' `
                    -replace 'Serviceachat','ServiceAchat' `
                    -replace 'Protectiondesdonneesetconformite','ProtectionDesDonneesEtConformite' `
                    -replace 'Proprieteintellectuelle','ProprieteIntellectuelle' | Set-Content -Path 'C:\users\Administrator\Desktop\BillU.csv'

}

function CreateOUUtilisateur
{

    $chemin = "OU=Utilisateurs,DC=BillU,DC=lan"

    $csv = Import-Csv -Path "C:\Users\Administrator\Desktop\BillU.csv" -Delimiter "," -header "Prenom" , "Nom","Société","Site",`
                "Département","Service","fonction","Manager - prénom","Manager - nom","Date de naissance","email","Téléphone fixe","Téléphone portable" `
                ,"Nomadisme - Télétravail" -Encoding UTF8 | Select-Object -Skip 1


    #Supprimer les doublons
    $dataUnique = $csv | Sort-Object -Property "Département" -Unique | Select-Object

    #Parcourir chaque ligne du fichier CSV unique
    foreach ($row in $dataUnique) 
        {
            # Votre logique ici
        }
 
    $dataUnique | Export-Csv -Path 'C:\Users\Administrator\Desktop\BillU.csv' -NoTypeInformation 

    $dataUnique = $dataUnique | Select-Object -Property "Département"


    # Parcourir chaque ligne du fichier CSV et créer une OU pour chaque département
    foreach ($departement in $dataUnique) 
        {
            $nomOU = $departement.Département
            $cheminOU = "OU=$nomOU,$chemin"
    
            # Vérifier si l'OU n'existe pas déjà
            if (-not (Get-ADOrganizationalUnit -Filter {Name -eq $nomOU})) 
                {
                    New-ADOrganizationalUnit -Name $nomOU -Path $chemin 
                    Write-Host "Création de l'OU $cheminOU" -ForegroundColor Green
                    Log -FilePath $LogFile -Content "Création de l'OU $cheminOU"
                } 
            else 
                {
                    Write-Host "L'OU `"$cheminOU`" existe déjà." -ForegroundColor Yellow -BackgroundColor Black
                       Log -FilePath $LogFile -Content "NoCréation- OU `"$cheminOU`" déjà éxistant"
                }
        }
}

Function DptSrv
{

    $csv = Import-Csv -Path "C:\Users\Administrator\Desktop\BillU.csv"  
    $csv = $csv  | Select-Object -Property Service, 'D?partement' | Export-Csv -Path 'C:\Users\Administrator\Desktop\BillU.csv'  -NoTypeInformation

    $csv = import-csv -path "C:\Users\Administrator\Desktop\BillU.csv"

    #Supprimer les doublons
    $dataUnique = $csv | Sort-Object -Property Service -Unique | Select-Object -Skip 1

    #Parcourir chaque ligne du fichier CSV unique
    foreach ($row in $dataUnique) 
        {
            # Votre logique ici
        }
 
    $dataUnique | Export-Csv -Path "C:\Users\Administrator\Desktop\BillU.csv" -NoTypeInformation 

    $File = "C:\Users\administrator\desktop\BillU.csv"
    $OUs = Import-Csv -Path $File 

}

Function CreateSousOUUtilisateur
{
    $File = "C:\Users\administrator\desktop\BillU.csv"
    $OUs = Import-Csv -Path $File 
    Foreach ($OU in $OUs)
        {
            CreateSousOUUtilisateurFunction -OU $OU.Service -SearchBase $OU.'D?partement'
        }
}

function CreateSousOUUtilisateurFunction
{
    param ([Parameter(Mandatory=$True, Position=0)][String]$OU,
            [Parameter(Mandatory=$True, Position=1)][ValidateSet("DptRecrutement","DptJuridique","DptFinanceEtComptabilite","DptCommercial","DptQHSE","DptDirection","DptDSI","DptDeveloppementLogiciel","DptCommunicationEtRelationsPubliques")][String]$SearchBase)
    
    Switch ($SearchBase)
        {
            "DptRecrutement" {$DNSearchBase = "OU=DptRecrutement,OU=Utilisateurs,DC=BillU,DC=lan"}
            "DptJuridique" {$DNSearchBase = "OU=DptJuridique,OU=Utilisateurs,DC=BillU,DC=lan"}
            "DptFinanceEtComptabilite" {$DNSearchBase = "OU=DptFinanceEtComptabilite,OU=Utilisateurs,DC=BillU,DC=lan"}
            "DptCommercial" {$DNSearchBase = "OU=DptCommercial,OU=Utilisateurs,DC=BillU,DC=lan"}
            "DptQHSE" {$DNSearchBase = "OU=DptQHSE,OU=Utilisateurs,DC=BillU,DC=lan"}
            "DptDirection" {$DNSearchBase = "OU=DptDirection,OU=Utilisateurs,DC=BillU,DC=lan"}
            "DptDSI" {$DNSearchBase = "OU=DptDSI,OU=Utilisateurs,DC=BillU,DC=lan"}
            "DptDeveloppementLogiciel" {$DNSearchBase = "OU=DptDeveloppementLogiciel,OU=Utilisateurs,DC=BillU,DC=lan"}
            "DptCommunicationEtRelationsPubliques" {$DNSearchBase = "OU=DptCommunicationEtRelationsPubliques,OU=Utilisateurs,DC=BillU,DC=lan"}
        }

    If((Get-ADOrganizationalUnit -Filter {Name -like $ou} -SearchBase $DNSearchBase) -eq $Null)
        {
            New-ADOrganizationalUnit -Name $OU -Path $DNSearchBase
            $OUObj = Get-ADOrganizationalUnit "ou=$OU,$DNSearchBase"
            $OUObj | Set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion:$False
            Write-Host "Création du Sous-OU $($OUObj.DistinguishedName)" -ForegroundColor Green
            Log -FilePath $LogFile -Content "Création du Sous-OU $($OUObj.DistinguishedName)"
        }
    Else
        {
            Write-Host "Le Sous-OU `"OU=$OU,$DNSearchBase`" existe déjà" -ForegroundColor Yellow -BackgroundColor Black
               Log -FilePath $LogFile -Content "NoCréation- Sous-OU `"OU=$OU,$DNSearchBase`" déjà éxistant"
        }
}

function Creategrp1
{

    $chemin = "OU=Utilisateurs,DC=BillU,DC=lan"

    $csv = Import-Csv -Path "C:\Users\Administrator\Desktop\BillU.csv" -Delimiter "," -header "Prenom" , "Nom","Société","Site",`
                "Département","Service","fonction","Manager - prénom","Manager - nom","Date de naissance","email","Téléphone fixe","Téléphone portable" `
                ,"Nomadisme - Télétravail" -Encoding UTF8 | Select-Object -Skip 1


    #Supprimer les doublons
    $dataUnique = $csv | Sort-Object -Property Département -Unique | Select-Object

    #Parcourir chaque ligne du fichier CSV unique
    foreach ($row in $dataUnique) 
        {
            # Votre logique ici
        }
 
    $dataUnique | Export-Csv -Path 'C:\Users\Administrator\Desktop\BillU.csv' -NoTypeInformation 

    $dataUnique = $dataUnique | Select-Object -Property Département
    

    # Parcourir chaque ligne du fichier CSV et créer une OU pour chaque département
    foreach ($departement in $dataUnique) 
        {
            $nomOU = $departement.Département
            $cheminou = "OU=$nomOU,$chemin"
    
            # Vérifier si l'OU n'existe pas déjà
            if (-not (Get-ADGroup -Filter {Name -eq $nomOU})) 
                {
                    New-ADGroup -Name $nomOU -Path $cheminou -GroupScope Global -GroupCategory Security
                    Write-Host "Création du Groupe $nomOU" -ForegroundColor Green
                    Log -FilePath $LogFile -Content "Création du Groupe $nomOU"
                    
                } 
            else 
                {
                    Write-Host "Le Groupe `"$nomOU`" existe déjà." -ForegroundColor Yellow -BackgroundColor Black
                    Log -FilePath $LogFile -Content "NoCréation- Groupe $nomOU déjà éxistant"
                }
        }
}

function Creategrp2
{

    $chemin = "OU=Utilisateurs,DC=BillU,DC=lan"

    $csv = Import-Csv -Path "C:\Users\Administrator\Desktop\BillU.csv" 


    # Parcourir chaque ligne du fichier CSV et créer une OU pour chaque département
    foreach ($departement in $csv) 
    {
        $nomOU = $departement.'Service'
        $DPT = $departement.'D?partement'
        $cheminou = "OU=$nomOU,OU=$DPT,$chemin"
    
        # Vérifier si l'OU n'existe pas déjà
        if (-not (Get-ADGroup -Filter {Name -eq $nomOU})) 
            {
                New-ADGroup -Name $nomOU -Path $cheminou -GroupScope Global -GroupCategory Security
                Write-Host "Création du Sous-Groupe $nomOU" -ForegroundColor Green
                     Add-ADGroupMember -Identity $dpt -Members $nomOU
                     Write-Host "Ajout du groupe $nomOU au groupe $DPT" -foregroundColor Green
                Log -FilePath $LogFile -Content "Création du Sous-Groupe $nomOU et Ajout aux groupe $DPT"
            }
        else 
            {
                Write-Host "Le Sous-Groupe `"$nomOU`" existe déjà." -ForegroundColor Yellow -BackgroundColor Black
                Log -FilePath $LogFile -Content "NoCréation- Sous-groupe `"$nomOU`" déjà éxistant"
            }
    }
}

Function CreateUser
{

    $Users = Import-Csv -Path "C:\Users\Administrator\Desktop\BillU.csv" -Delimiter "," -header "Prenom" , "Nom","Société","Site",`
                "Département","Service","fonction","Manager - prénom","Manager - nom","Date de naissance","email","Téléphone fixe","Téléphone portable" `
                ,"Nomadisme - Télétravail" -Encoding UTF8 | Select-Object -Skip 1


    $ADUsers = Get-ADUser -Filter * -Properties *
    $count = 1
    Foreach ($User in $Users)
        {
        Write-Progress -Activity "Création des Utilisateurs dans l'OU et Ajout au groupe correspondant" -Status "%effectué" -PercentComplete ($Count/$Users.Length*100)
        $Name              = "$($User.Nom) $($User.Prenom)"
        $DisplayName       = "$($User.Nom) $($User.Prenom)"
        $SamAccountName    = $($User.Prenom.substring(0,1).tolower()) + "." + $($User.Nom.ToLower())
        $UserPrincipalName = (($User.prenom.substring(0,1).tolower() + $User.nom.ToLower()) + "@" + (Get-ADDomain).Forest)
        $GivenName         = $User.Prenom
        $Surname           = $User.Nom
            if ($($user.Service) -eq "")
                {
                    $path = "ou=$($user.Département),OU=Utilisateurs,dc=BillU,dc=lan"
                }
            else
                {
                    $path = "ou=$($user.service),ou=$($user.Département),OU=Utilisateurs,dc=BillU,dc=lan"
                }
        $Company           = "BillU"
        $Department        = "$($User.Département)"
        $Service           = "$($User.Service)"
        
        If (($ADUsers | Where {$_.SamAccountName -eq $SamAccountName}) -eq $Null)
            {
                New-ADUser -Name $Name -DisplayName $DisplayName -SamAccountName $SamAccountName -UserPrincipalName $UserPrincipalName `
                -GivenName $GivenName -Surname $Surname `
                -Path $Path -AccountPassword (ConvertTo-SecureString -AsPlainText Azerty1* -Force) -Enabled $True `
                -OtherAttributes @{Company = $Company;Department = $Department} -ChangePasswordAtLogon $True
                  Write-Host "Création de l'Utilisateur $SamAccountName" -ForegroundColor Green
                        if ($($user.service) -eq "")
                        {
                            Add-ADGroupMember -Identity "$Department" -Members $SamAccountName 
                          Write-Host "Ajout de l'Utilisateur $SamAccountName au groupe $Department" -ForegroundColor Green
                        }
                        else
                        {
                            Add-ADGroupMember -Identity "$Service" -Members $SamAccountName 
                          Write-Host "Ajout de l'Utilisateur $SamAccountName au groupe $Service" -ForegroundColor Green
                        }
                  Log -FilePath $LogFile -Content "Création de l'Utilisateur $SamAccountName et Ajout au groupe correspondant"
            }
        Else
            {
                Write-Host "L'Utilisateur $SamAccountName existe déjà et est déjà affecté au groupe corespondant" -ForegroundColor Yellow -BackgroundColor Black
                Log -FilePath $LogFile -Content "NoCréation- Utilisateur $SamAccountName déjà éxistant"
            }
                $Count++
                sleep -Milliseconds 100
         }
}

Function FormatCsv2
{
    NormalizeCsv2 ; RemplaceMot2
}

Function NormalizeCsv2 
{
    # Importer le fichier CSV initial
    $Users = Import-Csv -Path $path2

    # Parcourir chaque ligne et chaque colonne pour supprimer les accents et les espaces
    foreach ($row in $Users) 
        {
            foreach ($property in $row.PSObject.Properties)
                {
                    # Supprimer les accents
                    $property.Value = $property.Value.Normalize('FormD') -replace '[^\p{IsBasicLatin}]', ''
                    # Supprimer les espaces
                    $property.Value = $property.Value.Replace(' ', '')
                }
        }

    # Exporter les données dans un nouveau fichier CSV
    $Users | Export-Csv -Path 'C:\Users\Administrator\Desktop\BillU2.csv' -NoTypeInformation
}

Function RemplaceMot2
{
    (Get-Content -Path 'C:\users\Administrator\Desktop\BillU2.csv') `
                    -replace 'servicerecrutement','DptRecrutement' -replace 'servicecommercial','DptCommercial' `
                    -replace 'FinanceetComptabilite','DptFinanceEtComptabilite' -replace 'QHSE','DptQHSE' `
                    -replace 'ServiceJuridique','DptJuridique' -replace 'Direction','DptDirection' `
                    -replace 'Developpementlogiciel','DptDeveloppementLogiciel' `
                    -replace 'CommunicationetRelationspubliques','DptCommunicationEtRelationsPubliques' `
                    -replace 'DSI','DptDSI' -replace 'Communicationinterne','CommunicationInterne' -replace 'Gestiondesmarques','GestionDesMarques' `
                    -replace 'Testetqualite','TestEtQualite' `
                    -replace 'analyseetconception','AnalyseEtConception' `
                    -replace 'AdministrationSystemesetReseaux','AdministrationSystemesEtReseaux' `
                    -replace 'DeveloppementetIntegration','DeveloppementEtIntegration' `
                    -replace 'RechercheetPrototype','RechercheEtPrototype' `
                    -replace 'Gestionenvironnementale','GestionEnvironnementale' `
                    -replace 'Serviceachat','ServiceAchat' `
                    -replace 'Protectiondesdonneesetconformite','ProtectionDesDonneesEtConformite' `
                    -replace 'Proprieteintellectuelle','ProprieteIntellectuelle' | Set-Content -Path 'C:\users\Administrator\Desktop\BillU2.csv'

}

function ModifAD
{
    $Users = Import-Csv -Path "C:\Users\Administrator\Desktop\BillU2.csv" -Delimiter "," -header "Prenom" , "Nom","Société","Site",`
                "Département","Service","fonction","Manager - prénom","Manager - nom","Date de naissance","email","Téléphone fixe","Téléphone portable" `
                ,"Nomadisme - Télétravail" -Encoding UTF8 | Select-Object -Skip 1


    $ADUsers = Get-ADUser -Filter * -Properties *
    $count = 1
    Foreach ($User in $Users)
{
    Write-Progress -Activity "Modifications des Utilisateurs en cours" -Status "%effectué" -PercentComplete ($Count/$Users.Length*100)
    $Name              = "$($User.Nom) $($User.Prenom)"
    $DisplayName       = "$($User.Nom) $($User.Prenom)"
    $SamAccountName    = $($User.Prenom.substring(0,1).tolower()) + "." + $($User.Nom.ToLower())
    $UserPrincipalName = (($User.prenom.substring(0,1).tolower() + $User.nom.ToLower()) + "@" + (Get-ADDomain).Forest)
    $GivenName         = $User.Prenom
    $Surname           = $User.Nom

    if ($($user.Service) -eq "")
        {
            $path = "ou=$($user.Département),OU=Utilisateurs,dc=BillU,dc=lan"
        }
    else
        {
            $path = "ou=$($user.service),ou=$($user.Département),OU=Utilisateurs,dc=BillU,dc=lan"
        }
    $Company           = "BillU"
    $Department        = "$($User.Département)"
    $Service           = "$($User.Service)"
    $Telephone         = "$($User.'Téléphone fixe')"
    $portable          = "$($User.'Téléphone portable')"
    $birthday          = "$($User.'Date de naissance')"
    $email             = "$($User.email)"
    $site              = "$($User.Site)"
    $manager           = "$($User.'Manager - nom') $($User.'Manager - prénom')"
    
     
     If (($ADUsers | Where {$_.SamAccountName -eq $SamAccountName}))
        {
            if ($($user.service) -eq "")
            {
                 $cheminDossierPartage = "\\$nameordi\Users\Administrator\Desktop\PersonnalData\$SamAccountName" 
                 
                 set-ADUser -Identity $SamAccountName -OfficePhone $Telephone -MobilePhone $portable -EmailAddress $email -Office $site `
                    -Description $birthday -HomeDirectory $cheminDossierPartage -HomeDrive "I:" 
                 New-Item $cheminDossierPartage -ItemType Directory
                 Write-Host "Mise à jour des informations de l'Utilisateur $SamAccountName et creation dossier personnel" -ForegroundColor Green
                 Log -FilePath $LogFile -Content "Mise à jour informations Utilisateurs $SamAccountName"
            }
        else
            {
                $cheminDossierPartage = "\\$nameordi\Users\Administrator\Desktop\PersonnalData\$SamAccountName"
                
                 set-ADUser -Identity $SamAccountName -OfficePhone $Telephone -MobilePhone $portable -EmailAddress $email -Office $site `
                    -Description $birthday -Title $Service -HomeDirectory $cheminDossierPartage -HomeDrive "I:"
                 New-Item $cheminDossierPartage -ItemType Directory
                 Write-Host "Mise à jour des informations de l'Utilisateur $SamAccountName et creation dossier personnel" -ForegroundColor Green
                  Log -FilePath $LogFile -Content "Mise à jour informations Utilisateurs $SamAccountName"
            }
        }
    Else
        {
            Write-Host "L'Utilisateur $SamAccountName n'existe pas" -ForegroundColor Yellow -BackgroundColor Black
             Log -FilePath $LogFile -Content "NoMise à jour- Utilisateurs $SamAccountName déjà éxistant"
        }
            $Count++
            sleep -Milliseconds 100
     }
 }

function rangement
{
    $cheminFichierCSV1 = "C:\users\Administrator\Desktop\BillU.csv"
    $cheminFichierCSV2 = "C:\Users\Administrator\Desktop\BillU2.csv"

    # Charger les données des fichiers CSV
    $fichierCSV1 = Import-Csv -Path $cheminFichierCSV1 -Delimiter "," -Header "Prenom" , "Nom","Société","Site",`
                "Département","Service","fonction","Manager - prénom","Manager - nom","Date de naissance","email","Téléphone fixe","Téléphone portable" `
                ,"Nomadisme - Télétravail" | Select-Object -Skip 1
    $fichierCSV2 = Import-Csv -Path $cheminFichierCSV2 -Delimiter "," -Header "Prenom" , "Nom","Société","Site",`
                "Département","Service","fonction","Manager - prénom","Manager - nom","Date de naissance","email","Téléphone fixe","Téléphone portable" `
                ,"Nomadisme - Télétravail" | Select-Object -Skip 1

    # Comparer les fichiers et afficher les différences
    $differences = Compare-Object -ReferenceObject $fichierCSV1 -DifferenceObject $fichierCSV2 -Property  "Prenom" , "Nom" , "Département" , "Service"
                 

    if ($differences) 
        {
            foreach ($diff in $differences) 
                {
                    if ($diff.SideIndicator -eq "=>") 
                        {
   
                            $Name              = "$($diff.Nom) $($diff.Prenom)"
                            $DisplayName       = "$($diff.Nom) $($diff.Prenom)"
                            $SamAccountName    = $($diff.Prenom.substring(0,1).tolower()) + "." + $($diff.Nom.ToLower())
                            $UserPrincipalName = (($diff.prenom.substring(0,1).tolower() + $diff.nom.ToLower()) + "@" + (Get-ADDomain).Forest)
                            $GivenName         = $diff.Prenom
                            $Surname           = $diff.Nom

                               if ($($diff.Service) -eq "")
                                    {
                                        $path = "ou=$($diff.Département),OU=Utilisateurs,dc=BillU,dc=lan"
                                    }
                                else
                                    {
                                        $path = "ou=$($diff.service),ou=$($diff.Département),OU=Utilisateurs,dc=BillU,dc=lan"
                                    }
                            $Company           = "BillU"
                            $Department        = "$($diff.Département)"
        

                                If (($ADUsers | Where {$_.SamAccountName -eq $SamAccountName}))
                                    {
                                          New-ADUser -Name $Name -DisplayName $DisplayName -SamAccountName $SamAccountName -UserPrincipalName $UserPrincipalName `
                                            -GivenName $GivenName -Surname $Surname `
                                            -Path $Path -AccountPassword (ConvertTo-SecureString -AsPlainText Azerty1* -Force) -Enabled $True `
                                            -OtherAttributes @{Company = $Company;Department = $Department} -ChangePasswordAtLogon $True 
                                            Write-Host "Activation de l'utilisateur $name SAM: $samaccountname" -ForegroundColor Green
                                            Log -FilePath $LogFile -Content "Activation de l'utilisateur $name SAM: $samaccountname"
                                    }
                                else
                                    {
                                        $samAccountName = "$samaccountName`1"
                                        $UserPrincipalName = (($diff.prenom.substring(0,1).tolower() + $diff.nom.ToLower()) + "1" + "@" + (Get-ADDomain).Forest)
                                         New-ADUser -Name $Name -DisplayName $DisplayName -SamAccountName $SamAccountName -UserPrincipalName $UserPrincipalName `
                                            -GivenName $GivenName -Surname $Surname `
                                            -Path $Path -AccountPassword (ConvertTo-SecureString -AsPlainText Azerty1* -Force) -Enabled $True `
                                            -OtherAttributes @{Company = $Company;Department = $Department} -ChangePasswordAtLogon $True 
                                         Write-Host "Activation de l'utilisateur $name SAM: $samaccountname" -ForegroundColor Green
                                          Log -FilePath $LogFile -Content "Activation de l'utilisateur $name SAM: $samaccountname"
                                    }

                            } 
                                elseif ($diff.SideIndicator -eq "<=") 
                                    {
                                        $samAccountName = $($Diff.Prenom.substring(0,1).tolower()) + "." + $($diff.Nom.ToLower())
                                        $targetname = "OU=UtilisateursDesactive,dc=billu,dc=lan"
                                        $name = "$($diff.Nom) $($diff.Prenom)" 
                                        $info = Get-ADUser -Identity $samaccountname
                                        Disable-ADAccount -Identity $samAccountName
                                        Move-ADObject -Identity $info.distinguishedname -TargetPath $targetname -Confirm:$false
                                        Write-Host "Désactivation de l'utilisateur $samAccountName" -ForegroundColor Green
                                         Log -FilePath $LogFile -Content "Désactivation de l'utilisateur $samAccountName"
            
                                    }
                }
        } 
    else 
        {
             Write-Host "Les fichiers CSV sont identiques, aucune différence trouvée."
              Log -FilePath $LogFile -Content "NoMise à jour- Fichiers CSV identiques"
        }
}

function CreateOUOrdinateur
{

    $chemin = "OU=Ordinateurs,DC=BillU,DC=lan"

    $csv = Import-Csv -Path "C:\Users\Administrator\Desktop\BillU.csv" -Delimiter "," -header "Prenom" , "Nom","Société","Site",`
                "Département","Service","fonction","Manager - prénom","Manager - nom","Date de naissance","email","Téléphone fixe","Téléphone portable" `
                ,"Nomadisme - Télétravail" -Encoding UTF8 | Select-Object -Skip 1


    #Supprimer les doublons
    $dataUnique = $csv | Sort-Object -Property "Département" -Unique | Select-Object

    #Parcourir chaque ligne du fichier CSV unique
    foreach ($row in $dataUnique) 
        {
            # Votre logique ici
        }
 
    $dataUnique | Export-Csv -Path 'C:\Users\Administrator\Desktop\BillU.csv' -NoTypeInformation 

    $dataUnique = $dataUnique | Select-Object -Property "Département"


    # Parcourir chaque ligne du fichier CSV et créer une OU pour chaque département
    foreach ($departement in $dataUnique) 
        {
            $nomOU = $departement.Département
            $cheminOU = "OU=$nomOU,$chemin"
    
            # Vérifier si l'OU n'existe pas déjà
            if (-not (Get-ADOrganizationalUnit -Filter {DistinguishedName -eq $cheminOU})) 
                {
                    New-ADOrganizationalUnit -Name $nomOU -Path $chemin 
                    Write-Host "Création de l'OU $cheminOU" -ForegroundColor Green
                    Log -FilePath $LogFile -Content "Création de l'OU $cheminOU"
                } 
            else 
                {
                    Write-Host "L'OU `"$cheminOU`" existe déjà." -ForegroundColor Yellow -BackgroundColor Black
                     Log -FilePath $LogFile -Content "NoCréation- OU `"$cheminOU`" déjà éxistant"
                }
        }
}

Function CreateSousOUOrdinateur
{
    $File = "C:\Users\administrator\desktop\BillU.csv"
    $OUs = Import-Csv -Path $File 
    Foreach ($OU in $OUs)
        {
            CreateSousOUFunctionOrdinateur -OU $OU.Service -SearchBase $OU.'D?partement'
        }
}

function CreateSousOUFunctionOrdinateur
{
    param ([Parameter(Mandatory=$True, Position=0)][String]$OU,
            [Parameter(Mandatory=$True, Position=1)][ValidateSet("DptRecrutement","DptJuridique","DptFinanceEtComptabilite","DptCommercial","DptQHSE","DptDirection","DptDSI","DptDeveloppementLogiciel","DptCommunicationEtRelationsPubliques")][String]$SearchBase)
    
    Switch ($SearchBase)
        {
            "DptRecrutement" {$DNSearchBase = "OU=DptRecrutement,OU=Ordinateurs,DC=BillU,DC=lan"}
            "DptJuridique" {$DNSearchBase = "OU=DptJuridique,OU=Ordinateurs,DC=BillU,DC=lan"}
            "DptFinanceEtComptabilite" {$DNSearchBase = "OU=DptFinanceEtComptabilite,OU=Ordinateurs,DC=BillU,DC=lan"}
            "DptCommercial" {$DNSearchBase = "OU=DptCommercial,OU=Ordinateurs,DC=BillU,DC=lan"}
            "DptQHSE" {$DNSearchBase = "OU=DptQHSE,OU=Ordinateurs,DC=BillU,DC=lan"}
            "DptDirection" {$DNSearchBase = "OU=DptDirection,OU=Ordinateurs,DC=BillU,DC=lan"}
            "DptDSI" {$DNSearchBase = "OU=DptDSI,OU=Ordinateurs,DC=BillU,DC=lan"}
            "DptDeveloppementLogiciel" {$DNSearchBase = "OU=DptDeveloppementLogiciel,OU=Ordinateurs,DC=BillU,DC=lan"}
            "DptCommunicationEtRelationsPubliques" {$DNSearchBase = "OU=DptCommunicationEtRelationsPubliques,OU=Ordinateurs,DC=BillU,DC=lan"}
        }

    If((Get-ADOrganizationalUnit -Filter {Name -like $ou} -SearchBase $DNSearchBase) -eq $Null)
        {
            New-ADOrganizationalUnit -Name $OU -Path $DNSearchBase
            $OUObj = Get-ADOrganizationalUnit "ou=$OU,$DNSearchBase"
            $OUObj | Set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion:$False
            Write-Host "Création du Sous-OU $($OUObj.DistinguishedName)" -ForegroundColor Green
            Log -FilePath $LogFile -Content "Création du Sous-OU $($OUObj.DistinguishedName)"
        }
    Else
        {
            Write-Host "Le Sous-OU `"OU=$OU,$DNSearchBase`" existe déjà" -ForegroundColor Yellow -BackgroundColor Black
             Log -FilePath $LogFile -Content "NoCréation-  Sous-OU `"OU=$OU,$DNSearchBase`" déjà éxistant"
        }
}

Function Set-LogonHours
{
   [CmdletBinding()]
   Param
   (
    [Parameter(Mandatory=$True)][ValidateRange(0,23)]$TimeIn24Format,
    [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True,Position=0)]$Identity,
    [parameter(mandatory=$False)][ValidateSet("WorkingDays", "NonWorkingDays")]$NonSelectedDaysare="NonWorkingDays",
    [parameter(mandatory=$false)][switch]$Sunday,
    [parameter(mandatory=$false)][switch]$Monday,
    [parameter(mandatory=$false)][switch]$Tuesday,
    [parameter(mandatory=$false)][switch]$Wednesday,
    [parameter(mandatory=$false)][switch]$Thursday,
    [parameter(mandatory=$false)][switch]$Friday,
    [parameter(mandatory=$false)][switch]$Saturday
   )
    Process
   {
    $FullByte=New-Object "byte[]" 21
    $FullDay=[ordered]@{}
    0..23 | foreach{$FullDay.Add($_,"0")}
    $TimeIn24Format.ForEach({$FullDay[$_]=1})
    $Working= -join ($FullDay.values)
    Switch ($PSBoundParameters["NonSelectedDaysare"])
   {
    'NonWorkingDays' {$SundayValue=$MondayValue=$TuesdayValue=$WednesdayValue=$ThursdayValue=$FridayValue=$SaturdayValue="000000000000000000000000"}
    'WorkingDays' {$SundayValue=$MondayValue=$TuesdayValue=$WednesdayValue=$ThursdayValue=$FridayValue=$SaturdayValue="111111111111111111111111"}
   }
   Switch ($PSBoundParameters.Keys)
   {
    'Sunday' {$SundayValue=$Working}
    'Monday' {$MondayValue=$Working}
    'Tuesday' {$TuesdayValue=$Working}
    'Wednesday' {$WednesdayValue=$Working}
    'Thursday' {$ThursdayValue=$Working}
    'Friday' {$FridayValue=$Working}
    'Saturday' {$SaturdayValue=$Working}
   }

   $AllTheWeek="{0}{1}{2}{3}{4}{5}{6}" -f $SundayValue,$MondayValue,$TuesdayValue,$WednesdayValue,$ThursdayValue,$FridayValue,$SaturdayValue

   # Timezone Check
   if ((Get-TimeZone).baseutcoffset.hours -lt 0){
    $TimeZoneOffset = $AllTheWeek.Substring(0,168+ ((Get-TimeZone).baseutcoffset.hours))
    $TimeZoneOffset1 = $AllTheWeek.SubString(168 + ((Get-TimeZone).baseutcoffset.hours))
    $FixedTimeZoneOffSet="$TimeZoneOffset1$TimeZoneOffset"
   }
   if ((Get-TimeZone).baseutcoffset.hours -gt 0){
    $TimeZoneOffset = $AllTheWeek.Substring(0,((Get-TimeZone).baseutcoffset.hours))
    $TimeZoneOffset1 = $AllTheWeek.SubString(((Get-TimeZone).baseutcoffset.hours))
    $FixedTimeZoneOffSet="$TimeZoneOffset1$TimeZoneOffset"
   }
   if ((Get-TimeZone).baseutcoffset.hours -eq 0){
    $FixedTimeZoneOffSet=$AllTheWeek
   }

   $i=0
   $BinaryResult=$FixedTimeZoneOffSet -split '(\d{8})' | Where {$_ -match '(\d{8})'}

   Foreach($singleByte in $BinaryResult){
    $Tempvar=$singleByte.tochararray()
    [array]::Reverse($Tempvar)
    $Tempvar= -join $Tempvar
    $Byte = [Convert]::ToByte($Tempvar, 2)
    $FullByte[$i]=$Byte
    $i++
   }
   Set-ADUser -Identity $Identity -Replace @{logonhours = $FullByte} 
}
end{
   Write-Host "La plage horaire des utilisateurs a été modifier" -ForegroundColor green
    Log -FilePath $LogFile -Content "Mise à jour plage horaire des utilisateurs"

}
}








