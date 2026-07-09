function Get-OperatingSystemInfo {

    Write-Progress `
        -Activity "AssetCollector" `
        -Status "Obteniendo sistema operativo..." `
        -PercentComplete 20

    try {

        $OS = Get-CimInstance Win32_OperatingSystem

        return [PSCustomObject]@{

            Caption = $OS.Caption
            Version = $OS.Version
            Build = $OS.BuildNumber
            Architecture = $OS.OSArchitecture
            InstallDate = $OS.InstallDate
            LastBoot = $OS.LastBootUpTime

        }

    }
    catch {

        Write-Host $_ -ForegroundColor Red
        return $null

    }

}