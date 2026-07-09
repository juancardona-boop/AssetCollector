function Get-ComputerInfo {

    Write-Progress `
        -Activity "AssetCollector" `
        -Status "Obteniendo informacion del equipo..." `
        -PercentComplete 10

    try {

        $Computer = Get-CimInstance Win32_ComputerSystem
        $BIOS = Get-CimInstance Win32_BIOS
        $Product = Get-CimInstance Win32_ComputerSystemProduct

        return [PSCustomObject]@{

            ComputerName = $env:COMPUTERNAME

            UserName = $env:USERNAME

            Domain = $env:USERDOMAIN

            Manufacturer = $Computer.Manufacturer

            Model = $Computer.Model

            SerialNumber = $BIOS.SerialNumber

            UUID = $Product.UUID

        }

    }
    catch {

        return $null

    }

}