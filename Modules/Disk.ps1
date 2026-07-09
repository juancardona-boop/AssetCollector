function Get-DiskInfo {

    Write-Progress `
        -Activity "AssetCollector" `
        -Status "Obteniendo almacenamiento..." `
        -PercentComplete 80

    $Resultado = @()

    try{

        $PhysicalDisks = Get-CimInstance Win32_DiskDrive

        foreach($PhysicalDisk in $PhysicalDisks){

            $Partitions = @()

            $DiskPartitions = Get-CimAssociatedInstance `
                -InputObject $PhysicalDisk `
                -Association Win32_DiskDriveToDiskPartition

            foreach($Partition in $DiskPartitions){

                $LogicalDisks = Get-CimAssociatedInstance `
                    -InputObject $Partition `
                    -Association Win32_LogicalDiskToPartition

                foreach($LogicalDisk in $LogicalDisks){

                    $SizeGB = [math]::Round($LogicalDisk.Size / 1GB,2)
                    $FreeGB = [math]::Round($LogicalDisk.FreeSpace / 1GB,2)
                    $UsedGB = $SizeGB - $FreeGB

                    if($SizeGB -gt 0){
                        $PercentUsed = [math]::Round(($UsedGB / $SizeGB) * 100,0)
                    }
                    else{
                        $PercentUsed = 0
                    }

                    $Partitions += [PSCustomObject]@{

                        Drive       = $LogicalDisk.DeviceID
                        FileSystem  = $LogicalDisk.FileSystem
                        SizeGB      = $SizeGB
                        FreeGB      = $FreeGB
                        UsedGB      = $UsedGB
                        PercentUsed = $PercentUsed

                    }

                }

            }

            $MediaType = "Desconocido"

            if($PhysicalDisk.Model -match "SSD"){
                $MediaType = "SSD"
            }

            if($PhysicalDisk.Model -match "NVME"){
                $MediaType = "NVMe SSD"
            }

            if($PhysicalDisk.Model -match "HDD"){
                $MediaType = "HDD"
            }

            $Resultado += [PSCustomObject]@{

                Index        = $PhysicalDisk.Index
                Model        = $PhysicalDisk.Model.Trim()
                Manufacturer = $PhysicalDisk.Manufacturer
                Interface    = $PhysicalDisk.InterfaceType
                Serial       = $PhysicalDisk.SerialNumber
                SizeGB       = [math]::Round($PhysicalDisk.Size / 1GB,2)
                MediaType    = $MediaType
                Partitions   = $Partitions

            }

        }

    }
    catch{

    }

    return $Resultado

}