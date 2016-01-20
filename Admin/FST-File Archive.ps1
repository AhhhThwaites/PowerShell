<#
    Type: File System Task  
    File: FST-File Archive.ps1
    Desc: Script to move and delete files older than n days
    Date: 18/01/2016  
    
#>

#Variables
$Now = Get-Date
$Days = "5"
$TargetFolder = "D:\A-Copy\"
$Extension = "*.ps1"
$Debug = "1"

#define LastWriteTime parameter based on $Days
$LastWrite = $Now.AddDays(-$Days)

#get files based on lastwrite filter and specified folder
$Files = Get-Childitem $TargetFolder -Include $Extension -Recurse | Where {$_.LastWriteTime -le "$LastWrite"}

#delete aforementioned files
foreach ($File in $Files)
    {
    if ($File -ne $NULL)
        {
        if ($Debug -eq 0)
            {
                write-host "Deleting File $File" -ForegroundColor "DarkRed"
                Remove-Item $File.FullName | out-null
            }
            else
            {
                Write-Host "DEBUG MODE: "($File).FullName"" -ForegroundColor "Green"
            }
        }
    else
        {
        Write-Host "No files found to delete!" -foregroundcolor "Red"
        }
    }