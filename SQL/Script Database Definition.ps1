<#
    File: Script Database Definition.ps1
    Desc: Based on a script from Nigel Rivett, minor alterations to include a database inclusion list.
    Date: 27/01/2016  
#>

$strPath = "D:\Workspace Temp\"
$strServerName = "."
 
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO') | Out-Null
$strServerInstance = New-Object ('Microsoft.SqlServer.Management.Smo.Server') $strServerName

$objDatabases = @('SSISDB','DBTestData')
$objIncludeTypes = @('Tables','StoredProcedures','Views','UserDefinedFunctions')
$objExcludeSchemas = @('sys', 'Information_Schema')
 
#set $objScriptingOptions, check options addtional to this within debug or online.
$objScriptingOptions = new-object ('Microsoft.SqlServer.Management.Smo.ScriptingOptions')
$objScriptingOptions.IncludeIfNotExists = 1
$objScriptingOptions.SchemaQualify = 1
$objScriptingOptions.AllowSystemObjects = 0
$objScriptingOptions.ScriptDrops = 0
$objScriptingOptions.IncludeHeaders = 1
$objScriptingOptions.Indexes = 1
$objScriptingOptions.Triggers = 1

#foreach database within $strServerInstance
foreach ($objFeDatabase in $strServerInstance.Databases)
    {
        # write-host $objFeDatabase
        #if I'm specified in $objDatabases
        if ($objDatabases -contains $objFeDatabase.Name)
            {
                #string manipulation
                
                $strDatabase = "$objFeDatabase".replace("[","").replace("]","")
                $strFePath = $strPath+$strDatabase+"\"
                
                #if my Database path doesn't exist, create it.
                if ( !(Test-Path $strFePath))
                    {
                        $null=new-item -type directory -Path $strFePath
                    }
                
                #if my Object path doesn't exist, create it.
                foreach ($objFeType in $objIncludeTypes)
                    {
                        $strFeObjPath = $strFePath+$objFeType+"\"
                        if ( !(Test-Path $strFeObjPath))
                            {
                                $null=new-item -type directory -Path $strFeObjPath
                            }
                    
                        #foreach "thing" within the current DB and current type i.e. Table, View etc.
                        foreach ($objs in $objFeDatabase.$objFeType)
                        {
                            If ($objExcludeSchemas -notcontains $objs.Schema ) 
                                {
                                    $objName = "$objs".replace("[","").replace("]","")                  
                                    $objScriptingOptions.FileName = $strFeObjPath + "$objName" + ".sql"   
                                    $objs.Script($objScriptingOptions) | Out-Null
                                }
                        }
                    }     
            } 
    }
