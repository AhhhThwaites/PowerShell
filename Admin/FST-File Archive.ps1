<#
    Type: File System Task  
    File: FST-File Archive.ps1
    Desc: Script to move and delete files older than n days
    Date: 18/01/2016  
    
#>

#Variables
$Now = Get-Date
$Days = "5"
$TargetFolder = "D:\SVN\Development\"
$Extension = "*.snp"

#define LastWriteTime parameter based on $Days
$LastWrite = $Now.AddDays(-$Days)

#get files based on lastwrite filter and specified folder
$Files = Get-Childitem $TargetFolder -Include $Extension -Recurse | Where {$_.LastWriteTime -le "$LastWrite"}

#delete aforementioned files
foreach ($File in $Files)
    {
    if ($File -ne $NULL)
        {
        write-host "Deleting File $File" #-ForegroundColor "DarkRed"
        #Remove-Item $File.FullName | out-null
        }
    else
        {
        Write-Host "No more files to delete!" #-foregroundcolor "Green"
        }
    }