$here = Split-Path $MyInvocation.MyCommand.Path

Get-Module FileSystemTasks | Remove-Module -Force
Import-Module "$here\FileSystemTasks\FileSystemTasks.psm1"

Get-AgedFiles -Days 1 -TargetFolder "D:\Git\" -Extension "*.ps1"

# Get-AgedFiles -Days 1 -TargetFolder "$here" -Extension "*.ps1"

# Get-FileSizeSummary "D:\GIt"
# Remove-AgedFiles -Days 1 -TargetFolder "D:\DacPac\" -Extension "*.dacpac" -DebugMode $true

$WebData = Invoke-RestMethod 'http://feed.nashownotes.com/rss.xml'
foreach ($thing in $WebData)
{
    $thing.link
}