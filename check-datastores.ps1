Connect-VIServer "vcenter"
$timestamp = Get-date -format "_yyMMdd_HHmmss"
$reportPath="C:\reports\datastoresSpace" + $timestamp + ".csv"

$datastores = Get-Datastore | Select -Property Name, Datacenter,
	@{N="CapacityGB";E={[math]::round($_.ExtensionData.Summary.Capacity/1GB)}},
	@{N="ProvisionedGB"; E={[math]::round(($_.ExtensionData.Summary.Capacity - $_.ExtensionData.Summary.FreeSpace + $_.ExtensionData.Summary.Uncommitted)/1GB)}},
	@{N="FreeSpaceGB";E={[math]::round($_.ExtensionData.Summary.FreeSpace/1GB)}},
	@{N="Status";E={"OK"}}, 
	@{N="PercentFree";E={"0"}}, @{N="Comment";E={""}} | Sort-Object -Property Name
$result=@()
foreach ($datastore in $datastores)
	{
		$datastore.PercentFree=[math]::Round(100*$datastore.FreeSpaceGB/$datastore.CapacityGB)
		if($datastore.ProvisionedGB -gt $datastore.CapacityGB){
			$datastore.Comment="Capacity space is less then Provisioned space of datastore"
			if($datastore.PercentFree -lt "5"){
				$datastore.status="Critical"
			}
			else{
				$datastore.status="Warning"
			}
		}
		elseif($datastore.PercentFree -lt "5"){
			$datastore.status="Critical"
		}
		elseif($datastore.PercentFree -lt "10"){
			$datastore.status="Warning"
		}
		$result+=$datastore
		
	}
$result | export-csv -Path $reportPath -Delimiter ";" -NoTypeInformation
