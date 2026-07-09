function Export-InventoryJson {

    param(
        [Parameter(Mandatory)]
        [object]$Inventory,

        [Parameter(Mandatory)]
        [string]$OutputPath
    )

    try {

        $ComputerName = $Inventory.Computer.ComputerName

        $Date = Get-Date -Format "yyyyMMdd_HHmmss"

        $FileName = "Inventario_${ComputerName}_${Date}.json"

        $FullPath = Join-Path $OutputPath $FileName

        $Inventory |
            ConvertTo-Json -Depth 10 |
            Out-File -FilePath $FullPath -Encoding UTF8

        return $FullPath

    }
    catch {

        Write-Host ""
        Write-Host "Error generando JSON" -ForegroundColor Red
        Write-Host $_

        return $null

    }

}