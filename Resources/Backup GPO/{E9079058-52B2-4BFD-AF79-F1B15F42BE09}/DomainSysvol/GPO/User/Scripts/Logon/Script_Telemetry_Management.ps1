#################################
## SCRIPT TELEMETRY MANAGEMENT ##
#################################


<#
Se script réalise les taches suivantes: 
 - verifie les registre et les cle de registre afin de les créé, modifier
 - il va desactiver telemetrie, adverting ID, SmartScreen, OneDrive, DiagTrack, la géolocalisation ...
 - il va desactiver les sevices : skype, cortana, GrooveMusic, Film et TV ...
#>


Function ChangeReg 
    {
        param ([string] $RegKey,
               [string] $Value,
               [string] $SvcName,
               [Int] $CheckValue,
               [Int] $SetData)
        # Verification de l'existence de la cle de registre 
          Write-Host "Vérication que le service $SvcName est Activé" -ForegroundColor Green
         # Si elle n'existe pas , création de la clé
          if (!(Test-Path $RegKey))
            {
              Write-Host "Registry Key pour le service $SvcName n'existe pas, création réalisé" -ForegroundColor Yellow
              New-Item -Path (Split-Path $RegKey) -Name (Split-Path $RegKey -Leaf) 
            }
         $ErrorActionPreference = 'Stop'
        # controle de status du service si actif : il sera desactivé sinon affiche que le status est desactivé
         try
            {
              Get-ItemProperty -Path $RegKey -Name $Value 
              if((Get-ItemProperty -Path $RegKey -Name $Value).$Value -eq $CheckValue) 
                {
                  Write-Host "$SvcName est activé, désactivation en cours" -ForegroundColor Green
                  Set-ItemProperty -Path $RegKey -Name $Value -Value $SetData -Force
                }
              if((Get-ItemProperty -Path $RegKey -Name $Value).$Value -eq $SetData)
                {
                     Write-Host "$SvcName est désactivé" -ForegroundColor Green
                }
             } 
         # Si le registre n'existe pas il est créé et désactivé
         catch [System.Management.Automation.PSArgumentException] 
             {
               Write-Host "la clé de registre pour le service $SvcName n'existe pas, création et désactivation par defaut" -ForegroundColor Yellow
               New-ItemProperty -Path $RegKey -Name $Value -Value $SetData -Force
              }
    }
  
Clear-Host
 
 # Desactivation Advertising ID
     $RegKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
     $Value = "Enabled"
     $SvcName = "Advertising ID"
     $CheckValue = 1
     $SetData = 0

     ChangeReg -RegKey $RegKey -Value $Value -SvcName $SvcName -CheckValue $CheckValue -SetData $SetData
 

 #Desactivation Telemetrie
     $RegKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
     $Value = "AllowTelemetry"
     $SvcName = "Telemetry"
     $CheckValue = 1
     $SetData = 0   
          
     ChangeReg -RegKey $RegKey -Value $Value -SvcName $SvcName -CheckValue $CheckValue -SetData $SetData        
 
     $RegKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
     $Value = "AllowDeviceNameInTelemetry"
     $SvcName = "AllowDevices"
     $CheckValue = 1
     $SetData = 0     
        
     ChangeReg -RegKey $RegKey -Value $Value -SvcName $SvcName -CheckValue $CheckValue -SetData $SetData        

     $RegKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
     $Value = "AllowTelemetry"
     $SvcName = "Telemetry"
     $CheckValue = 1
     $SetData = 0        

     ChangeReg -RegKey $RegKey -Value $Value -SvcName $SvcName -CheckValue $CheckValue -SetData $SetData        

     $RegKey = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
     $Value = "AllowTelemetry"
     $SvcName = "Telemetry"
     $CheckValue = 1
     $SetData = 0     
        
     ChangeReg -RegKey $RegKey -Value $Value -SvcName $SvcName -CheckValue $CheckValue -SetData $SetData        


# Desactivation SmartScreen 
     $RegKey = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost\EnableWebContentEvaluation"
     $Value = "Enabled"
     $SvcName = "Smart Screen"
     $CheckValue = 1
     $SetData = 0
     ChangeReg -RegKey $RegKey -Value $Value -SvcName $SvcName -CheckValue $CheckValue -SetData $SetData

# Desactivation OneDrive
     Write-Host "Désactivation du service OneDrive" -ForegroundColor Green 
     Get-Process -Name OneDrive -ErrorAction SilentlyContinue | Stop-Process -ErrorAction SilentlyContinue
     Write-Host "le service OneDrive est désactivé" -ForegroundColor Green


# Desactivation Diagtrack (outil rapport erreur Microsoft)
     Write-Host "Désactivation des services DiagTrack" -ForegroundColor Green 
     Get-Service -Name DiagTrack | Set-Service -StartupType Disabled | Stop-Service
     Get-Service -Name dmwappushservice | Set-Service -StartupType Disabled | Stop-Service
     Write-Host "les services DiagTrack sont désactivés" -ForegroundColor Green


# Desactivation Geolocalisation 
     Write-Host "Désactivation de service lfsvc (géolocalisation)" -ForegroundColor Green 
     Get-Service -Name lfsvc | Set-Service -StartupType Disabled | Stop-Service
     Write-Host "le service lfsvc est désactivé (géolocalisation)" -ForegroundColor Green 


# Désactivation Télémétrie de tache Programmée
     Write-Host "désactivation de telemetry scheduled tasks" -ForegroundColor Green
     $tasks ="ProgramDataUpdater","Microsoft Compatibility Appraiser","Proxy","Consolidator",
             "CreateObjectTask","Microsoft-Windows-DiskDiagnosticDataCollector","WinSAT",
             "GatherNetworkInfo"
     $ErrorActionPreference = 'Stop'
     $tasks | %{
        try
        {
           Get-ScheduledTask -TaskName $_ | Disable-ScheduledTask
        } 
        catch [Microsoft.PowerShell.Cmdletization.Cim.CimJobException] 
        { 
        "la tache $($_.TargetObject) pas trouvé"
        }
     }


# Désinstaller Cortana, skype, GrooveMusic, Cinema et TV, Solitaire 
     Write-Host "Suppression des paquets d'installation Cortana, skype, GrooveMusic, Cinema et TV, Solitaire" -ForegroundColor Green 
     Get-AppxPackage *Microsof.549981C3F5F10* | Remove-AppxPackage
     Get-AppxPackage *zunemusic* | Remove-AppPackage
     Get-AppxPackage *skypeapp* | Remove-AppxPackage
     Get-AppxPackage *zunevideo* | Remove-AppxPackage
     Get-AppxPackage *solitairecollection* | Remove-AppxPackage
     Write-Host "les services Cortana, skype, GrooveMusic, Cinema et TV, Solitaire ont été supprimés" -ForegroundColor Green 



