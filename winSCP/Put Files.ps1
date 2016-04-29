<#
    Type: winSCP
    File: Put Files.ps1
    Desc: Script to upload a set of files in a given directory.
    Date: 29/04/2016
#>

try
{
    Add-Type -Path "C:\Program Files (x86)\WinSCP\WinSCPnet.dll"
 
    $sessionOptions = New-Object WinSCP.SessionOptions
    $sessionOptions.Protocol = [WinSCP.Protocol]::Sftp
    $sessionOptions.HostName = "aHost"
    $sessionOptions.UserName = "aUser"
    $sessionOptions.SshHostKeyFingerprint = "ssh-rsa 1024 key details"
    $sessionOptions.SshPrivateKeyPath = "D:\Scripts\akey.ppk"
    $sessionOptions.AddRawSettings("ProxyHost","proxy.something.com")
    $sessionOptions.AddRawSettings("ProxyPort","8080")
    $sessionOptions.AddRawSettings("ProxyMethod","3")
    
    $session = New-Object WinSCP.Session
    $remotePath = "/pt/home/"
    $localPath = "D:\Workspace\"

    try
    {
        $session.ExecutablePath = "C:\Program Files (x86)\WinSCP\WinSCP.exe"
        $session.Open($sessionOptions)
 
        foreach($file in get-childitem -path $localPath)
            {
                $localFile = $File.FullName
                $session.PutFiles($localFile, $remotePath)
            }
    }
    finally
    {
        #Disconnect, clean up
        Write-Host "cleaning connection"
        $session.Dispose()
    }

}
catch [Exception]
{
    Write-Host $_.Exception.Message
}