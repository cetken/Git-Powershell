function Get-SAPSQLServer {
  <#
  .SYNOPSIS
  Get SQL Server Name for and SAP System ID (SID)
  .DESCRIPTION
  Get the name of the current online DB server from MONUTIL.dbo.SQLDatabases table for a given SAP System ID
  .EXAMPLE
  Get-SAPSQLServer -SAPSystemID MST
  .PARAMETER SAPSystemID
  Three digit SAP System ID (SID)
  #>
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory=$True,
    ValueFromPipeline=$True,
    ValueFromPipelineByPropertyName=$True,
      HelpMessage='Which SAP System do you want to get the DB server name for?')]
    [Alias('SID')]
    [ValidateLength(3,3)]
    [string] $SAPSystemID
  )
  process {
    $SAPSystemID = $SAPSystemID.ToUpper()    
    Write-Verbose "Retrieving DB Server name for $SAPSystemID"
    $SQLServer = "SAPPRDMONDB"
    $SQLDatabase = "MONUTIL"
    $SQLSchema = "dbo"
    $SQLQuery = "select SQLServer from $SQLDatabase.$SQLSchema.SQLDatabases where DBName='$SAPSystemID' and Status='ONLINE'"
    $Result = Invoke-Sqlcmd `
        -Query $SQLQuery `
        -ServerInstance $SQLServer `
        -Database $SQLDatabase      

    Write-Output $Result.SQLServer
  }
}