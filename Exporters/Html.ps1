function Export-InventoryHtml {

    param(
        [object]$Inventory,
        [string]$OutputPath
    )

    $Computer = $Inventory.Computer
    $OS = $Inventory.OperatingSystem
    $CPU = $Inventory.CPU
    $RAM = $Inventory.Memory
    $BIOS = $Inventory.BIOS
    $Disks = $Inventory.Disks
    $Network = $Inventory.Network

    $Fecha = Get-Date -Format "yyyyMMdd_HHmmss"

    $Archivo = Join-Path $OutputPath "Inventario_$($Computer.ComputerName)_$Fecha.html"

    $DisksHtml = ""

    foreach($Disk in $Disks){

        $DisksHtml += @"
<tr>
<td>$($Disk.Drive)</td>
<td>$($Disk.SizeGB) GB</td>
<td>$($Disk.FreeGB) GB</td>
<td>$($Disk.UsedGB) GB</td>
<td>$($Disk.FileSystem)</td>
</tr>
"@

    }

    $NetworkHtml = ""

    foreach($NIC in $Network){

        $NetworkHtml += @"
<tr>
<td>$($NIC.Name)</td>
<td>$($NIC.IP)</td>
<td>$($NIC.MAC)</td>
<td>$($NIC.Gateway)</td>
</tr>
"@

    }

$Html = @"

<!DOCTYPE html>

<html>

<head>

<meta charset="utf-8">

<title>AssetCollector</title>

<link rel="stylesheet" href="../Resources/style.css">

</head>

<body>

<h1>AssetCollector</h1>

<h2>Inventario de Activos Tecnologicos</h2>

<div class="card">

<h3>Equipo</h3>

<table>

<tr><td class="label">Nombre</td><td>$($Computer.ComputerName)</td></tr>

<tr><td class="label">Usuario</td><td>$($Computer.UserName)</td></tr>

<tr><td class="label">Fabricante</td><td>$($Computer.Manufacturer)</td></tr>

<tr><td class="label">Modelo</td><td>$($Computer.Model)</td></tr>

<tr><td class="label">Serial</td><td>$($Computer.SerialNumber)</td></tr>

</table>

</div>

<div class="card">

<h3>Sistema Operativo</h3>

<table>

<tr><td class="label">Nombre</td><td>$($OS.Caption)</td></tr>

<tr><td class="label">Version</td><td>$($OS.Version)</td></tr>

<tr><td class="label">Build</td><td>$($OS.Build)</td></tr>

<tr><td class="label">Arquitectura</td><td>$($OS.Architecture)</td></tr>

</table>

</div>

<div class="card">

<h3>Hardware</h3>

<table>

<tr><td class="label">CPU</td><td>$($CPU.Name)</td></tr>

<tr><td class="label">Nucleos</td><td>$($CPU.Cores)</td></tr>

<tr><td class="label">Procesadores Logicos</td><td>$($CPU.LogicalProcessors)</td></tr>

<tr><td class="label">RAM</td><td>$($RAM.TotalGB) GB</td></tr>

<tr><td class="label">BIOS</td><td>$($BIOS.Version)</td></tr>

</table>

</div>

<div class="card">

<h3>Discos</h3>

<table>

<tr>

<th>Unidad</th>

<th>Tamano</th>

<th>Libre</th>

<th>Usado</th>

<th>Sistema de Archivos</th>

</tr>

$DisksHtml

</table>

</div>

<div class="card">

<h3>Adaptadores de Red</h3>

<table>

<tr>

<th>Nombre</th>

<th>IP</th>

<th>MAC</th>

<th>Gateway</th>

</tr>

$NetworkHtml

</table>

</div>

</body>

</html>

"@

    $Html | Out-File $Archivo -Encoding UTF8

    return $Archivo

}