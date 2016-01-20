<#
    Type: File System Task  
    File: File Size Summary.ps1
    Desc: Find what's consuming space in a given DIR, optionally recursive. Creates a .CSV output
    Date: 20/01/2016  
#>

function funcListDIR 
	{param ($strTargetDIR, $strOutputDIR, [bool]$isRecursive)
		if ($isRecursive -eq $true)
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

<#
    Examples:
        funcListDIR "C:\A-DBA\" "C:\A-DBA\Output.csv", 0
        funcListDIR "D:\SVN\Development\" "D:\Output.csv", 1
#>

funcListDIR "D:\SVN\Developement\Laterooms\" "D:\Output.csv" $false