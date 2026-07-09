#==============================================
# AssetCollector
#==============================================

$Root = Split-Path -Parent $MyInvocation.MyCommand.Path

. "$Root\Core\Initialize.ps1"

. "$Root\Modules\Computer.ps1"

. "$Root\Modules\OperatingSystem.ps1"

. "$Root\Modules\CPU.ps1"

. "$Root\Modules\Memory.ps1"

. "$Root\Modules\BIOS.ps1"

. "$Root\Modules\Disk.ps1"

. "$Root\Modules\Network.ps1"

. "$Root\Exporters\Json.ps1"

. "$Root\Exporters\Html.ps1"

Initialize-AssetCollector

$Global:AssetCollector.Inventory.Scan = [PSCustomObject]@{

    ScanId = [guid]::NewGuid().ToString()

    ScanDate = Get-Date

    AssetCollectorVersion = $Global:AssetCollector.Version

}

$Global:AssetCollector.Inventory.Computer = Get-ComputerInfo

$Global:AssetCollector.Inventory.OperatingSystem = Get-OperatingSystemInfo

$Global:AssetCollector.Inventory.CPU = Get-CPUInfo

$Global:AssetCollector.Inventory.Memory = Get-MemoryInfo

$Global:AssetCollector.Inventory.BIOS = Get-BIOSInfo

$Global:AssetCollector.Inventory.Disks = Get-DiskInfo

$Global:AssetCollector.Inventory.Network = Get-NetworkInfo

$Equipo = $Global:AssetCollector.Inventory.Computer
$SO = $Global:AssetCollector.Inventory.OperatingSystem
$CPU = $Global:AssetCollector.Inventory.CPU
$RAM = $Global:AssetCollector.Inventory.Memory
$BIOS = $Global:AssetCollector.Inventory.BIOS
$Disks = $Global:AssetCollector.Inventory.Disks
$Network = $Global:AssetCollector.Inventory.Network

Write-Host ""
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "RESUMEN DEL INVENTARIO"
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Equipo..............: $($Equipo.ComputerName)"
Write-Host "Usuario.............: $($Equipo.UserName)"
Write-Host "Fabricante..........: $($Equipo.Manufacturer)"
Write-Host "Modelo..............: $($Equipo.Model)"
Write-Host "Serial..............: $($Equipo.SerialNumber)"
Write-Host ""

Write-Host "Sistema Operativo...: $($SO.Caption)"
Write-Host "Version.............: $($SO.Version)"
Write-Host "Build...............: $($SO.Build)"
Write-Host ""

Write-Host "CPU.................: $($CPU.Name)"
Write-Host "Nucleos............ : $($CPU.Cores)"
Write-Host "Procesadores Logicos: $($CPU.LogicalProcessors)"
Write-Host ""

Write-Host "RAM Instalada.......: $($RAM.TotalGB) GB"
Write-Host ""

Write-Host "BIOS...............: $($BIOS.Manufacturer)"
Write-Host "BIOS Version.......: $($BIOS.Version)"
Write-Host ""

Write-Host "Discos encontrados.: $($Disks.Count)"
foreach($Disk in $Disks){
    Write-Host "   $($Disk.Drive)  $($Disk.SizeGB) GB  Libre: $($Disk.FreeGB) GB"
}

Write-Host ""

Write-Host "Adaptadores de Red.: $($Network.Count)"
foreach($NIC in $Network){
    Write-Host "   $($NIC.Name)"
}

Write-Host ""
Write-Host "Generando archivo JSON..." -ForegroundColor Cyan

$JsonFile = Export-InventoryJson `
                -Inventory $Global:AssetCollector.Inventory `
                -OutputPath $Global:AssetCollector.OutputPath

if($JsonFile){

    Write-Host ""
    Write-Host "JSON generado correctamente" -ForegroundColor Green
    Write-Host $JsonFile

}

Write-Host ""
Write-Host "Generando HTML..." -ForegroundColor Cyan

$HtmlFile=Export-InventoryHtml `
            -Inventory $Global:AssetCollector.Inventory `
            -OutputPath $Global:AssetCollector.OutputPath

if($HtmlFile){

    Write-Host "HTML generado correctamente." -ForegroundColor Green

    Write-Host $HtmlFile

}