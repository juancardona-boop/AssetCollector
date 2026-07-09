function Get-BaseBoardInfo {

    Write-Progress `
        -Activity "AssetCollector" `
        -Status "Obteniendo placa base..." `
        -PercentComplete 72

    try {

        $Board = Get-CimInstance Win32_BaseBoard

        return [PSCustomObject]@{

            Manufacturer = $Board.Manufacturer
            Product      = $Board.Product
            Model        = $Board.Product
            SerialNumber = $Board.SerialNumber
            Version      = $Board.Version

        }

    }
    catch {

        return $null

    }

}