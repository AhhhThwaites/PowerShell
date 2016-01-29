<#
    Type: File System Task  
    File: File Size Summary.ps1
    Desc: Find what's consuming space in a given DIR, optionally recursive. Creates a .CSV output
    Date: 20/01/2016  
#>

param 
(
    [string]$strTargetDIR = "D:\Workspace Temp\"
    ,[string]$strOutputDIR = "D:\Workspace Temp\output.csv"
    ,[bool]$boolRecursive = $false
)

begin
    {
        if ($boolRecursive -eq $true)
            {
                $files = get-childitem -path $strTargetDIR -rec | where {$_.mode -ne "d----"}
            }
            else
            {
                $files = get-childitem -path $strTargetDIR | where {$_.mode -ne "d----"}
            }
            
        $files | SELECT Mode `
                        ,LastWriteTime `
                        ,Name `
                        ,Extension `
                        ,@{Name="Kbytes";Expression={$_.Length / 1Kb}} `
                        ,@{Name="Mbytes";Expression={$_.Length / 1Mb}} `
                        ,Directory `
                        | Export-Csv -path $strOutputDIR -NoTypeInformation
    }