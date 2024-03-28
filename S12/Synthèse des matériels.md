### Réseau PARIS
|Nom Machine|Type|OS|Fonction|@IP/Mask|Disque/espace libre|RAM/%utilisé|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|PARIS-SRVWIN1|VM|Windows-server2022|AD|172.18.1.201/24|32Gio/20%|12Gio/20%|
|PARIS-SrvCore1|VM|Windows-server2022|Réplication|172.18.1.235/24|32Gio/60%|4Gio/72%|
|PARIS-SrvCore2|VM|Windows-server2022|Réplication|172.18.1.211/24|32Gio/60%|4Gio/72%|
|PARIS-pfsense-V2|VM|FreeBSD|PareFeu|Wan:192.168.1.242/24 Lan:172.18.1.1/24|4Gio/70%|4Gio/80%|
|PARIS-WSUS|VM|Windows-server2022|Gestion mise à  jour|172.18.1.230|C:32Gio/30% E:32Gio/1%|4Gio/65%|
|Zimbra|VM|Ubuntu-server18-04|Mail|172.18.1.220/24|25Gio/40%|4Gio/60%|
|PARIS-FREEPBX|VM|SNG7-PBX16-64bit-2302-1|VOIP|172.18.1.204/24|32Gio/65%|4Gio/65%|
|PARIS-SNORT|VM|Ubuntu22.04|Détection-sécurité|172.18.1.6/24|32Gio/40%|4Gio/50%|
|PARIS-PRTG|VM|Windows-server2022|Supervision Réseau|172.18.1.202|50Gio/60%|4Gio/75%|
|PARIS-KALI|VM|Linux-Kali|Test-Sécurité|172.18.1.11/24|32Gio/50%|4Gio/25%|
|PARIS-CLIWIN002|VM|Windows10|Client|172.18.1.40/24|50Gio/35%|8Gio/90%|
|PARIS-CLIWIN003|VM|Windows10|Client|172.18.1.75/24|50Gio/40%|8Gio/90%|



### Réseau LYON
|Nom Machine|Type|OS|Fonction|@IP/Mask|Disque/espace libre|RAM/%utilisé|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|LYON-pfsense-V2|VM|FreeBSD|PareFeu|Wan:192.168.1.243/24 Lan:10.10.5.1/24|4Gio/70%|4Gio/80%|
|LYON-CLIWIN001|VM|Windows10|Client|10.10.5.25|50Gio/60%|8Gio/90%|
