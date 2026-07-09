function Get-DiskInfo {

    Write-Progress `
        -Activity "AssetCollector" `
        -Status "Obteniendo discos..." `
        -PercentComplete 80

    $Resultado = @()

    try {

        $Discos = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"

        foreach($Disco in $Discos){

            $Resultado += [PSCustomObject]@{

                Drive = $Disco.DeviceID

                FileSystem = $Disco.FileSystem

                SizeGB = [math]::Round($Disco.Size/1GB,2)

                FreeGB = [math]::Round($Disco.FreeSpace/1GB,2)

                UsedGB = [math]::Round(($Disco.Size-$Disco.FreeSpace)/1GB,2)

            }

        }

    }
    catch{

    }

    return $Resultado

}