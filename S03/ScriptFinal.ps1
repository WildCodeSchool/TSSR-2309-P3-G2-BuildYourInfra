####################################################
####################  FONCTION  #################### 
####################################################


Function VerifAD
{
    If (-not(Get-Module -Name activedirectory))
    {
        Import-Module activedirectory
    }
}

Function CreateADForest
{
    # Vérifier si le domaine existe déjà
    $domainExists = Get-ADDomain -Server $domainName -ErrorAction SilentlyContinue

    if ($domainExists) 
        {
            Write-Host "Le domaine $domainName existe déjà." -ForegroundColor Yellow -BackgroundColor Black
        } 
    else 
    {
        # Créer la nouvelle forêt
        Install-ADDSForest -DomainName $domainName -DomainMode Win2012R2 -ForestMode Win2012R2 -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -LogPath "C:\Windows\NTDS" -SysvolPath "C:\Windows\SYSVOL" -Force -Verbose
        Write-Host "Création du domaine $domainName" -ForegroundColor Green
    }

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
        } 
    else 
        {
            Write-Host "L'OU $ouUsers existe déjà." -ForegroundColor Yellow -BackgroundColor Black
        }

    if (-not $ouComputersExists) 
        {
        New-ADOrganizationalUnit -Name $ouComputers -Path "$domainName1"
        Write-Host "Création de l'OU OU=$ouComputers,DC=BillU,DC=lan" -ForegroundColor Green
        } 
    else 
        {
        Write-Host "L'OU $ouComputers,DC=BillU,DC=lan existe déjà." -ForegroundColor Yellow -BackgroundColor Black
        }
    if (-not $ouSecuriteExists) 
        {
            New-ADOrganizationalUnit -Name $ouSecurite -Path "$domainName1"
            Write-Host "Création de l'OU OU=$ouSecurite,DC=BillU,DC=lan" -ForegroundColor Green
        } 
    else 
        {
            Write-Host "L'OU $ouSecurite existe déjà." -ForegroundColor Yellow -BackgroundColor Black
        }
    if (-not $ouDisableComputerExists) 
        {    
            New-ADOrganizationalUnit -Name $ouDisableComputer -Path "$domainName1"
            Write-Host "Création de l'OU OU=$ouDisableComputer,DC=BillU,DC=lan" -ForegroundColor Green
        }     
    else 
        {
            Write-Host "L'OU $ouDisableComputer existe déjà." -ForegroundColor Yellow -BackgroundColor Black
        }
    if (-not $ouDisableUserExists) 
        {
            New-ADOrganizationalUnit -Name $ouDisableUser -Path "$domainName1"
            Write-Host "Création de l'OU OU=$ouDisableUser,DC=BillU,DC=lan" -ForegroundColor Green
        } 
    else 
        {
            Write-Host "L'OU $ouDisableUser existe déjà." -ForegroundColor Yellow -BackgroundColor Black
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

function CreateOU
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
                } 
            else 
                {
                    Write-Host "L'OU `"$cheminOU`" existe déjà." -ForegroundColor Yellow -BackgroundColor Black
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

Function CreateSousOU
{
    $File = "C:\Users\administrator\desktop\BillU.csv"
    $OUs = Import-Csv -Path $File 
    Foreach ($OU in $OUs)
        {
            CreateSousOUFunction -OU $OU.Service -SearchBase $OU.'D?partement'
        }
}

function CreateSousOUFunction
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
        }
    Else
        {
            Write-Host "Le Sous-OU `"OU=$OU,$DNSearchBase`" existe déjà" -ForegroundColor Yellow -BackgroundColor Black
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
                } 
            else 
                {
                    Write-Host "Le Groupe `"$nomOU`" existe déjà." -ForegroundColor Yellow -BackgroundColor Black
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
            }
        else 
            {
                Write-Host "Le Sous-Groupe `"$nomOU`" existe déjà." -ForegroundColor Yellow -BackgroundColor Black
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
        Write-Progress -Activity "Création des utilisateurs dans l'OU" -Status "%effectué" -PercentComplete ($Count/$Users.Length*100)
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
            }
        Else
            {
                Write-Host "L'Utilisateur $SamAccountName existe déjà" -ForegroundColor Yellow -BackgroundColor Black
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
            set-ADUser -Identity $SamAccountName -OfficePhone $Telephone -MobilePhone $portable -EmailAddress $email -Office $site `
                    -Description $birthday 
            Write-Host "Mise à jour des informatiions de l'Utilisateur $SamAccountName" -ForegroundColor Green
        }
    Else
        {
            Write-Host "L'Utilisateur $SamAccountName n'existe pas" -ForegroundColor Yellow -BackgroundColor Black
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
                                            -OtherAttributes @{Company = $Company;Department = $Department} -ChangePasswordAtLogon $True `
                                            Write-Host "Activation de l'utilisateur $name SAM: $samaccountname" -ForegroundColor Green
                                    }
                                else
                                    {
                
                                        $samAccountName = "$samaccountName`1"
                                        $UserPrincipalName = (($diff.prenom.substring(0,1).tolower() + $diff.nom.ToLower()) + "1" + "@" + (Get-ADDomain).Forest)
                                         New-ADUser -Name $Name -DisplayName $DisplayName -SamAccountName $SamAccountName -UserPrincipalName $UserPrincipalName `
                                            -GivenName $GivenName -Surname $Surname `
                                            -Path $Path -AccountPassword (ConvertTo-SecureString -AsPlainText Azerty1* -Force) -Enabled $True `
                                            -OtherAttributes @{Company = $Company;Department = $Department} -ChangePasswordAtLogon $True `
                                         Write-Host "Activation de l'utilisateur $name SAM: $samaccountname" -ForegroundColor Green
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
            
                                    }
                }
        } 
    else 
        {
             Write-Host "Les fichiers CSV sont identiques, aucune différence trouvée."
        }
}




##########################################################
####################  INITIALISATION  #################### 
##########################################################


$path1 = "C:\Users\Administrator\Desktop\s09_SocieteBillU.xlsx_-_Sheet1.csv"
$path2 = "C:\Users\Administrator\Desktop\s10_SocieteBillU.xlsx_-_Sheet1_1.csv"
$File = "C:\Users\administrator\desktop\BillU.csv"
$domainName = "billu.lan"
$domainName1 = "DC=billu,DC=lan"
$ouUsers = "Utilisateurs"
$ouComputers = "Ordinateurs"
$ouSecurite = "Securite"
$ouDisableUser = "UtilisateursDesactive"
$ouDisableComputer = "MachinesDesactive"

################################################
####################  MAIN  #################### 
################################################


Clear-Host

VerifAD ;

CreateADForest ;

Create1erOU ;

FormatCsv ; CreateOU ; Creategrp1

FormatCsv ; DptSrv ; CreateSousOU ; Creategrp2

FormatCsv ; CreateUser ;

FormatCsv2 ; ModifAD ; 

rangement






