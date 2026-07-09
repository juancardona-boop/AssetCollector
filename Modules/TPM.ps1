function Get-TPMInfo {

    Write-Progress `
        -Activity "AssetCollector" `
        -Status "Obteniendo TPM..." `
        -PercentComplete 76

    try {

        $TPM = Get-Tpm -ErrorAction Stop

        return [PSCustomObject]@{

            Present = $TPM.TpmPresent
            Ready = $TPM.TpmReady
            Enabled = $TPM.TpmEnabled
            Activated = $TPM.TpmActivated
            Owned = $TPM.TpmOwned
            Manufacturer = $TPM.ManufacturerIdTxt
            Version = $TPM.ManufacturerVersion

        }

    }
    catch {

        return [PSCustomObject]@{

            Present = $false
            Ready = $false
            Enabled = $false
            Activated = $false
            Owned = $false
            Manufacturer = ""
            Version = ""

        }

    }

}