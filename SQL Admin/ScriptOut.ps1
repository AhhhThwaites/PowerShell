clear 

#load assembly
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO') | Out-Null
$serverInstance = New-Object ('Microsoft.SqlServer.Management.Smo.Server') $ServerName

Remove-Variable -name so

#scripting options
$so = new-object (‘Microsoft.SqlServer.Management.Smo.ScriptingOptions’)
$so.IncludeIfNotExists = 0
$so.SchemaQualify = 1
$so.AllowSystemObjects = 0
$so.ScriptDrops = 0

#script specifics
$path = “C:\DBA\PowerShell-Out\"
$ServerName = ""
$dbs = $serverInstance.Databases | where {$_.name -eq "ProviderAdmin"}

Remove-Variable -name objName
Remove-Variable -name objSchema

$IncludedSchemas = @(“laterooms”,”search”,”affiliate”, ”global”,"search_v1_4")
$objname = @("GetDiscountSpecialOffers","GetExtranetHotelRates","GetExtranetRateDetails","GetHotelRates","GetProviderHotelRates","GetProviderRateDetails",
"GetAddedValueSpecialOffers","GetAppliedSpecialOffers","GetDiscountSpecialOffers","GetFreeNightSpecialOffers","GetPackageSpecialOffers","GetRoomReleasePeriod","ParseIntegerArrayAsInt",
"StayDates","GetProviderHotelRates","GetRates","GetStoredRates")

$IncludeTypes = @(”StoredProcedures”,"UserDefinedFunctions")


$dbname = "$db".replace("[","").replace("]","")
$dbpath = "$path"+"$ServerName" + "\"


foreach ($thing in $dbs.StoredProcedures)
    {
        if ($objname -eq $thing.Name -and $IncludedSchemas -eq $thing.Schema)
        {
            $thingname = $thing.Schema+"."+($thing.name).replace("[","").replace("]","")+".sql"
            $thing.Script($so) | Out-File $dbpath"StoredProcedures\"$thingname
        }
    }


foreach ($thing in $dbs.UserDefinedFunctions)
    {
        if ($objname -eq $thing.Name -and $IncludedSchemas -eq $thing.Schema)
        {
            $thingname = $thing.Schema+"."+($thing.name).replace("[","").replace("]","")+".sql"
            $thing.Script($so) | Out-File $dbpath"UserDefinedFunctions\"$thingname
        }
    }


