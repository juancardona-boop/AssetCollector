function Get-MemoryInfo {

    Write-Progress `
        -Activity "AssetCollector" `
        -Status "Obteniendo memoria..." `
        -PercentComplete 50

    try {

        $Computer = Get-CimInstance Win32_ComputerSystem

        return [PSCustomObject]@{

            TotalGB = [math]::Round($Computer.TotalPhysicalMemory / 1GB,2)

        }

    }
    catch {

        return $null

    }

}