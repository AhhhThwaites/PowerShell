<#
    Type: Server Insight
    File: SI-CPU Info.ps1
    Desc: PowerShell function written to accept a list of machines, outputs CPU info
    Date: 19/01/2016  
#>

Function Get-CPUInfo{
    [CmdletBinding()]
    Param(
    [parameter(Mandatory = $TRUE,ValueFromPipeline = $TRUE)]   [String] $ComputerName

    )

    Process{
            #Get processors information            
            $CPU=Get-WmiObject -ComputerName $ComputerName -class Win32_Processor
            #Get Computer model information
            $OS_Info=Get-WmiObject -ComputerName $ComputerName -class Win32_ComputerSystem
     
           #Reset number of cores and use count for the CPUs counting
           $CPUs = 0
           $Cores = 0
           
           foreach($Processor in $CPU){

           $CPUs = $CPUs+1   
           
           #count the total number of cores         
           $Cores = $Cores+$Processor.NumberOfCores
        
          } 
           $InfoRecord = New-Object -TypeName PSObject -Property @{
                    Server = $ComputerName;
                    Model = $OS_Info.Model;
                    SocketsUsed = $CPUs;
                    TotalCores = $Cores;
                    'Cores to CPUs Ratio' = $Cores/$CPUs;
    }
   Write-Output $InfoRecord
          }
}

#Machine list below, could make this a script param...
$srvArray=@()
$srvArray+="DBDEV01"
$srvArray+="DBTEST01"
$srvArray+=$env:COMPUTERNAME

#loop through the server list and get information about CPUs, Cores and Default instance edition
$srvArray | Foreach-Object {Get-CPUInfo $_ } | format-table -AutoSize