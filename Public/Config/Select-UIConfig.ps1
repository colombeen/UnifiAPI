<#
    .SYNOPSIS
      Select which connection information to load from the Unifi API config file

    .DESCRIPTION
      Select which connection information to load from the config file for Unifi API

    .PARAMETER Name
      The name of the config information

    .EXAMPLE
      PS C:\> Select-UIConfig
      Get the default connection information from the Unifi API config file and load it

    .EXAMPLE
      PS C:\> Select-UIConfig -name 'Company 2'
      Get the connection information with the name 'Company 2' from the Unifi API config file and load it
#>
Function Select-UIConfig
{
  [CmdletBinding(DefaultParameterSetName = 'Default')]
  Param
  (
    [Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'Name', Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Name
  )

  Begin
  {
    $Config = @(Get-UIConfig)
  }

  Process
  {
    $ConfigName = $Name

    $ConfigToLoad = $null

    Switch ($PSCmdlet.ParameterSetName)
    {
      'Default'
      {
        $ConfigToLoad = $Config | Where-Object { $_.Default -eq $true }
      }

      'Name'
      {
        $ConfigToLoad = $Config | Where-Object { $_.Name -eq $ConfigName }
      }
    }

    If ($null -ne $ConfigToLoad)
    {
      $ConfigToLoad | Set-UIConnection
    }
    Else
    {
      Throw 'No config to load'
    }
  }
}