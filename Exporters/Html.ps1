function New-DiskTable {

    param($Disks)

    $Table = @"
<table>
<thead>
<tr>
<th>Unidad / Disco</th>
<th>Tipo</th>
<th>Capacidad</th>
<th>Libre</th>
<th>Uso</th>
<th>Sistema</th>
</tr>
</thead>
<tbody>
"@

    foreach($Disk in $Disks){

        foreach($Partition in $Disk.Partitions){

            $Table += @"

<tr>

<td>

<b>$($Partition.Drive)</b><br>

<small>$($Disk.Model)</small>

</td>

<td>

$($Disk.MediaType)

</td>

<td>

$($Partition.SizeGB) GB

</td>

<td>

$($Partition.FreeGB) GB

</td>

<td>

<div class='progress'>

<div class='progress-bar' style='width:$($Partition.PercentUsed)%'></div>

</div>

$($Partition.PercentUsed)%

</td>

<td>

$($Partition.FileSystem)

</td>

</tr>

"@

        }

    }

    $Table += @"

</tbody>

</table>

"@

    return $Table

}

function New-NetworkTable {

    param($Network)

    $Table = @"

<table>

<thead>

<tr>

<th>Nombre</th>

<th>IP</th>

<th>MAC</th>

<th>Gateway</th>

</tr>

</thead>

<tbody>

"@

    foreach($NIC in $Network){

        $Table += @"

<tr>

<td>$($NIC.Name)</td>

<td>$($NIC.IP)</td>

<td>$($NIC.MAC)</td>

<td>$($NIC.Gateway)</td>

</tr>

"@

    }

    $Table += @"

</tbody>

</table>

"@

    return $Table

}

function Export-InventoryHtml {

    param(

        [Parameter(Mandatory)]
        [object]$Inventory,

        [Parameter(Mandatory)]
        [string]$OutputPath,

        [Parameter(Mandatory)]
        [string]$ResourcePath

    )

    $Template = Join-Path $ResourcePath "DashboardTemplate.html"

    if(!(Test-Path $Template)){
        throw "No existe DashboardTemplate.html"
    }

    $Html = Get-Content $Template -Raw

    $Computer = $Inventory.Computer
    $OS = $Inventory.OperatingSystem
    $CPU = $Inventory.CPU
    $RAM = $Inventory.Memory
    $BIOS = $Inventory.BIOS
    $Disks = $Inventory.Disks
    $Network = $Inventory.Network

    $DiskTable = New-DiskTable $Disks

    $NetworkTable = New-NetworkTable $Network

    $Replace = @{

        "{{ComputerName}}" = $Computer.ComputerName
        "{{UserName}}" = $Computer.UserName

        "{{Manufacturer}}" = $Computer.Manufacturer
        "{{Model}}" = $Computer.Model
        "{{Serial}}" = $Computer.SerialNumber

        "{{OSName}}" = $OS.Caption
        "{{OSVersion}}" = $OS.Version
        "{{Build}}" = $OS.Build

        "{{CPU}}" = $CPU.Name
        "{{Cores}}" = $CPU.Cores
        "{{Threads}}" = $CPU.LogicalProcessors

        "{{RAM}}" = $RAM.TotalGB

        "{{ScanDate}}" = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

        "{{Version}}" = $Inventory.Scan.AssetCollectorVersion

        "{{DiskTable}}" = $DiskTable

        "{{NetworkTable}}" = $NetworkTable

    }

        foreach($Item in $Replace.GetEnumerator()){

        $Html = $Html.Replace(
            $Item.Key,
            [string]$Item.Value
        )

    }

    $FileName = "Inventario_{0}_{1}.html" -f `
        $Computer.ComputerName, `
        (Get-Date -Format "yyyyMMdd_HHmmss")

    $FullPath = Join-Path `
        $OutputPath `
        $FileName

    $Html | Set-Content `
        -Path $FullPath `
        -Encoding UTF8

    return $FullPath

}