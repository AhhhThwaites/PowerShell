$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$module = "FileSystemTasks"

$here = Split-Path $MyInvocation.MyCommand.Path

Get-Module FileSystemTasks | Remove-Module -Force
Import-Module "$here\$module.psm1"

Describe "$module Tests" {
    Context 'Module Setup'{
            It "has root module $module" {
                "$here\$module.psm1" | Should Exist
            }

            It "$module is valid"{
                $psFile = Get-Content -Path "$here\$module.psm1" -ErrorAction Stop
                $errors = $null
                $null = [System.Management.Automation.PSParser]::Tokenize($psFile, [ref]$errors)
                $errors.Count | Should be 0
            }
        }

    Context "$module functions"{
            It "$module Get-AgedFiles"{
                $files = Get-AgedFiles -Days 1 -TargetFolder "D:\Git\" -Extension "*.ps1" 
                $files.Count | Should BeGreaterThan 0
            }
        }
        
        Write-Host $TestDrive
    }