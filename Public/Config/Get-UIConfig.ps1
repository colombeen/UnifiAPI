<#
    .SYNOPSIS
      Get connection information from the Unifi API config

    .DESCRIPTION
      Get connection information from the config file for Unifi API

    .PARAMETER Name
      The name of the config information

    .EXAMPLE
      PS C:\> Get-UIConfig
      Show all config information stored in the Unifi API config file

    .EXAMPLE
      PS C:\> Get-UIConfig -Name 'Company 2'
      Show the config information stored in the Unifi API config file with the name 'Company 2'
#>
Function Get-UIConfig
{
  Param
  (
    [Parameter(ValueFromPipelineByPropertyName = $true, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Name = '*'
  )

  Process
  {
    If ($null -ne $Script:UnifiAPI_Config_Path)
    {
      Try
      {
        Import-Clixml -Path $Script:UnifiAPI_Config_Path -ErrorAction SilentlyContinue | Where-Object { $_.Name -like $Name } | ForEach-Object {
          $_.APIKey = (New-Object -TypeName 'System.Management.Automation.PSCredential' -ArgumentList (0, $_.APIKey)).GetNetworkCredential().Password
          $_
        }
      }
      Catch
      {
        Write-Verbose $_
      }
    }
  }
}