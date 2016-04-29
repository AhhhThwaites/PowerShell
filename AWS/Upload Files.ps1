<#
    Type: AWS uploading
    File: Upload Files.ps1
    Desc: Script for uploading files to AWS S3 bucket!!
    Date: 25/04/2016
#>

$AWSModulePath = "C:\Program Files (x86)\AWS Tools\PowerShell\AWSPowerShell\AWSPowerShell.psd1"
$AWSBucket = "bktdev"
$AWSRegion = "us-west-2"
$AWSProfile = "Uploader"
$AWSSubDIR = "Test"
$ProxyHost = "dev-proxy.com"
$ProxyPort = "8080"
$SourceFolder = "C:\TestDir\"
$SourceType = "*.JPG"

Set-AWSProxy -Hostname $ProxyHost -Port $ProxyPort
Initialize-AWSDefaults -ProfileName $AWSProfile -Region $AWSRegion

If (Test-Path $AWSModulePath)
    {
        try 
            {
	            Import-Module $AWSModulePath -ErrorAction STOP
            }
        catch
            {
	            Write-Warning $_.Exception.Message
            }
    }
    else
        {
            Write-Warning "The AWS PowerShell module was not found on this computer."
        }

$Files = Get-ChildItem -Path $SourceFolder -Filter $SourceType

foreach ($file in $Files) 
    {
	    Write-Host $file
        $ffp = $file.FullName
        $fap = $AWSSubDIR+"/"+$file.Name
	    Write-S3Object -BucketName $AWSBucket -File $ffp -Key $fap
    }