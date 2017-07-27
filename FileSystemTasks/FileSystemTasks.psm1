<#

#>
function Get-AgedFiles{
[cmdletbinding()]
    param (
        [Parameter(Mandatory=$True)]
            [int]$Days 
        ,[Parameter(Mandatory=$True)]
            [string]$TargetFolder 
        ,[Parameter(Mandatory=$True)]
            [string]$Extension 
    )
    process
        {
        $Now = Get-Date
        $LastWrite = $Now.AddDays(-$Days)

        #get files based on lastwrite filter and specified folder
        $Files = Get-Childitem $TargetFolder -Include $Extension -Recurse | Where-Object {$_.LastWriteTime -le "$LastWrite"}

        foreach ($File in $Files)
            {
            if ($File -ne $NULL)
                {
                    Write-Output $File.FullName -ForegroundColor "Green"
                }
            else
                {
                    Write-Output "No files found with creteria!" -foregroundcolor "Red"
                }
            }
        }
    }
function Remove-AgedFiles{
[cmdletbinding()]
    param (
        [Parameter(Mandatory=$True)]
            [int]$Days 
        ,[Parameter(Mandatory=$True)]
            [string]$TargetFolder 
        ,[Parameter(Mandatory=$True)]
            [string]$Extension 
        ,[Parameter(Mandatory=$True)]
            [boolean]$DebugMode
    )
    process
        {
        $Now = Get-Date
        $LastWrite = $Now.AddDays(-$Days)

        #get files based on lastwrite filter and specified folder
        $Files = Get-Childitem $TargetFolder -Include $Extension -Recurse | Where-Object {$_.LastWriteTime -le "$LastWrite"}

        foreach ($File in $Files)
            {
            if ($File -ne $NULL)
                {
                if ($DebugMode -eq $false)
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
        }
    }
function Get-FileSizeSummary{
[cmdletbinding()]
    param (
        [Parameter(Mandatory=$True)]
            [string]$TargetDIR 
        ,[bool]$boolRecursive = $false
        )
    process
        {
            if ($boolRecursive -eq $true)
            {
                $files = get-childitem -path $TargetDIR -rec -File | where { ! $_.PSIsContainer }
            }
            else
            {
                $files = get-childitem -path $TargetDIR -File $True | where { ! $_.PSIsContainer }
            }
            
            $files | select-object  Mode `
                                    ,LastWriteTime `
                                    ,Name `
                                    ,Extension `
                                    ,@{Name="Kbytes";Expression={$_.Length / 1Kb}} `
                                    ,@{Name="Mbytes";Expression={$_.Length / 1Mb}} `
                                    ,Directory
            return "complete"
            }
        }