<#
    File: Redgate Compare Snapshots.ps1
    Desc: Creates Redgate software compatible snaphots & archives.
    Date: 18/01/2016  
#>

#Variables required.
$RedGateDIR = "C:\program files (x86)\red gate\SQL compare 10\"
$strTgtDBName = "Laterooms"
$strTgtDIR = "D:\RedgateSnapshot\"
$strDate = (get-date).ToString('dMMyyyy')

#Setup server array here
$srvArray=@()
$srvArray+="DEV"
$srvArray+="TEST"

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
        
        #write-host ".\SQLCompare.exe /Server1:$strServer /Database1:$strTgtDBName /MakeSnapshot:$strTgtDIRFull"
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
                    #Write-Host $file.FullName
                    Remove-Item -Path $file.FullName
                }
            }
    }