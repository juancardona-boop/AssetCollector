function Get-UUIDInfo {

    Write-Progress `
        -Activity "AssetCollector" `
        -Status "Obteniendo UUID..." `
        -PercentComplete 74

    try {

        $System = Get-CimInstance Win32_ComputerSystemProduct

        return [PSCustomObject]@{

            UUID = $System.UUID
            Vendor = $System.Vendor
            Name = $System.Name
            IdentifyingNumber = $System.IdentifyingNumber

        }

    }
    catch {

        return $null

    }

}