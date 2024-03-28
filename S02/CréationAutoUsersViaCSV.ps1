## attention changer DC :::

clear
$Users = Import-Csv -Path 'C:\Users\Administrator\Desktop\s09_SocieteBillU.xlsx - Sheet1.csv'

#Parcourir chaque ligne et chaque colonne pour supprimer les accents et les espaces
foreach ($row in $Users) {
    foreach ($property in $row.PSObject.Properties) {
        # Supprimer les accents
        $property.Value = $property.Value.Normalize('FormD') -replace '[^\p{IsBasicLatin}]'
        # Supprimer les espaces
        $property.Value = $property.Value.Replace(' ', '')
    }
}
#Exporter les données dans un nouveau fichier CSV
$Users | Export-Csv -Path 'C:\Users\Administrator\Desktop\BillU.csv' -NoTypeInformation

(Get-Content -Path 'C:\users\Administrator\Desktop\BillU.csv') -replace 'Direction', 'DptDirection' -replace 'servicerecrutement','DptRecrutement' -replace 'servicecommercial','DptCommercial' -replace 'FinanceetComptabilite','DptFinanceEtComptabilite' -replace 'QHSE','DptQhse' -replace 'ServiceJuridique','DptJuridique' -replace 'Developpementlogiciel','DptDeveloppementLogiciel' -replace'CommunicationetRelationspubliques','DptCommunicationEtRelationsPubliques' -replace'DSI','DptDsi' | Set-Content -Path 'C:\users\Administrator\Desktop\BillU.csv'

(Get-Content -Path 'C:\users\Administrator\Desktop\BillU.csv') -replace 'Communicationinterne','CommunicationInterne' -replace 'Gestiondesmarques','GestionDesMarques' -replace 'Testetqualite','TestEtQualite' -replace 'analyseetconception','AnalyseEtConception' -replace 'AdministrationSystemesetReseaux','AdministrationSystemesEtReseaux' -replace 'DeveloppementetIntegration','DeveloppementEtIntegration' -replace'RechercheetPrototype','RechercheEtPrototype' -replace'Gestionenvironnementale','GestionEnvironnementale' -replace 'Serviceachat','ServiceAchat' -replace 'Protectiondesdonneesetconformite','ProtectionDesDonneesEtConformite' -replace 'Proprieteintellectuelle','ProprieteIntellectuelle' -replace 'ADV','Adv' | Set-Content -Path 'C:\users\Administrator\Desktop\BillU.csv'

$Users = Import-Csv -Path 'C:\Users\Administrator\Desktop\BillU.csv'

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
        $path = "ou=$($user.'D?partement'),ou=BilluUsers,dc=billu,dc=lan"
    }
    else
    {
        $path = "ou=$($user.service),ou=$($user.'D?partement'),ou=BilluUsers,dc=billu,dc=lan"
    }
    $Company           = "BillU"
    $Department        = "$($User.'D?partement')"
    $Service           = "$($User.Service)"
     If (($ADUsers | Where {$_.SamAccountName -eq $SamAccountName}) -eq $Null)
    {
        New-ADUser -Name $Name -DisplayName $DisplayName -SamAccountName $SamAccountName -UserPrincipalName $UserPrincipalName `        -GivenName $GivenName -Surname $Surname `        -Path $Path -AccountPassword (ConvertTo-SecureString -AsPlainText Azerty1* -Force) -Enabled $True `        -OtherAttributes @{Company = $Company;Department = $Department} -ChangePasswordAtLogon $True                Write-Host "Création du USER $SamAccountName" -ForegroundColor Green    }
    Else
    {
        Write-Host "Le USER $SamAccountName existe déjà" -ForegroundColor Black -BackgroundColor Yellow
    }
    $Count++
    sleep -Milliseconds 100
}
