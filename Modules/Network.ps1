function Get-NetworkInfo {

    Write-Progress `
        -Activity "AssetCollector" `
        -Status "Obteniendo red..." `
        -PercentComplete 90

    $Resultado = @()

    try{

        $NICs = Get-CimInstance Win32_NetworkAdapterConfiguration |
                Where-Object {$_.IPEnabled}

        foreach($NIC in $NICs){

            $Resultado += [PSCustomObject]@{

                Name = $NIC.Description

                IP = ($NIC.IPAddress -join ", ")

                MAC = $NIC.MACAddress

                Gateway = ($NIC.DefaultIPGateway -join ", ")

                DHCP = $NIC.DHCPEnabled

            }

        }

    }
    catch{

    }

    return $Resultado

}