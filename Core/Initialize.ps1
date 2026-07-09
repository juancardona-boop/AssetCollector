function Initialize-AssetCollector {

    Clear-Host

    $Global:AssetCollector = [ordered]@{

        Version = "1.0.0"

        StartTime = Get-Date

        BasePath = Split-Path -Parent $MyInvocation.ScriptName

        OutputPath = ""

        LogPath = ""

        Inventory = [ordered]@{}

    }

    $Global:AssetCollector.OutputPath = Join-Path $PSScriptRoot "..\Output"

    $Global:AssetCollector.LogPath = Join-Path $PSScriptRoot "..\Logs"

    foreach($Folder in @(
        $Global:AssetCollector.OutputPath,
        $Global:AssetCollector.LogPath
    ))
    {
        if(!(Test-Path $Folder))
        {
            New-Item -ItemType Directory -Path $Folder | Out-Null
        }
    }

    Write-Host ""
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host "          ASSET COLLECTOR"
    Write-Host "=============================================" -ForegroundColor Cyan

    Write-Host ""
    Write-Host "Version :" $Global:AssetCollector.Version
    Write-Host "Inicio  :" $Global:AssetCollector.StartTime
    Write-Host ""

}