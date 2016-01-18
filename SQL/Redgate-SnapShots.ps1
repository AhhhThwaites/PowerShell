<#
    
    File: Redgate-SnapShots.ps1
    Desc: Creates Redgate software compatible snaphots
    Date: 18/01/2016  
    
#>

$RedGateDIR = "C:\program files (x86)\red gate\SQL compare 10\"

$strTgtDBName = "DatabaseName"
$strTgtDIR = "C:\A-DBA\Snapshots\"
$strDate = (get-date).ToString('dMMyyyy')

$srvArray=@()
$srvArray+="SRV01"
$srvArray+="SRV02"
$srvArray+="SRV03"
$srvArray+="SRV04"

#set working DIR
Set-Location -Path $RedGateDIR

#move out old files to base
foreach ($strfile in Get-ChildItem -Path $strTgtDIR*.snp)
    {
        $strfile.FullName
        Move-Item -Path $strfile.FullName -Destination $strTgtDIR"\Archive"
    }

#do some new snaphots
foreach ($strServer in $srvArray)
    {
        $strTgtDIRFull = """"+$strTgtDIR+$strServer+"-"+$strDate+".snp"+""""
        
        write-host ".\SQLCompare.exe /Server1:$strServer /Database1:$strTgtDBName /MakeSnapshot:$strTgtDIRFull"
        $exec = .\SQLCompare.exe /Server1:$strServer /Database1:$strTgtDBName /MakeSnapshot:$strTgtDIRFull
    }


#archive
$filelist = get-childitem -Path $strTgtDIR"\Archive\"

foreach ($file in $filelist)
    {
        $ts = new-timespan -Days -30
        
        #is the month on the file less than the current month?
        if (($file.CreationTime) -lt (get-date)+$ts)
            {
                if ((($file.CreationTime).Day) -gt 1) 
                {
                    Write-Host $file.FullName
                    Remove-Item -Path $file.FullName
                }
            }
    }
