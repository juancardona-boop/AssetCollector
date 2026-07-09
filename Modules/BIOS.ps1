function Get-BIOSInfo {

    Write-Progress `
        -Activity "AssetCollector" `
        -Status "Obteniendo BIOS..." `
        -PercentComplete 65

    try {

        $BIOS = Get-CimInstance Win32_BIOS

        return [PSCustomObject]@{

            Manufacturer = $BIOS.Manufacturer
            Version = $BIOS.SMBIOSBIOSVersion
            SerialNumber = $BIOS.SerialNumber
            ReleaseDate = $BIOS.ReleaseDate

        }

    }
    catch {

        Write-Host $_ -ForegroundColor Red
        return $null

    }

}