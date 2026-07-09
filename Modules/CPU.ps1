function Get-CPUInfo {

    Write-Progress `
        -Activity "AssetCollector" `
        -Status "Obteniendo procesador..." `
        -PercentComplete 35

    try {

        $CPU = Get-CimInstance Win32_Processor

        return [PSCustomObject]@{

            Name = $CPU.Name.Trim()

            Manufacturer = $CPU.Manufacturer

            Cores = $CPU.NumberOfCores

            LogicalProcessors = $CPU.NumberOfLogicalProcessors

            MaxClockMHz = $CPU.MaxClockSpeed

        }

    }
    catch {

        return $null

    }

}