<#
    .SYNOPSIS
      Add connection information to the Unifi API config

    .DESCRIPTION
      Add connection information to the config file for Unifi API

    .PARAMETER Name
      The name for this specific config information

    .PARAMETER APIKey
      The API key that will be used for authentication

    .PARAMETER Default
      Set this config information as the default one used by the module

    .EXAMPLE
      PS C:\> Add-UIConfig -Name 'Company' -APIKey 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx' -Default
      Add the config information for 'Company' to the Unifi API config file and make it the default config when the module gets loaded
#>
Function Add-UIConfig
{
  [CmdletBinding(ConfirmImpact = 'Low', SupportsShouldProcess = $true)]
  Param
  (
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Name,

    [Parameter(Mandatory = $true, Position = 1)]
    [ValidateNotNullOrEmpty()]
    [string]
    $APIKey,

    [Parameter(Position = 2)]
    [switch]
    $Default
  )

  Begin
  {
    $Config = @(Get-UIConfig)
  }

  Process
  {
    $ConfigName = $Name

    If ($PSCmdlet.ShouldProcess($ConfigName, 'Add'))
    {
      If ($ConfigName -in $Config.Name)
      {
        Throw ('Can''t use the name {0} because it is already in use' -f $ConfigName)
      }

      If ($Default.IsPresent)
      {
        $Config | ForEach-Object {
          $_.Default = $false
        }
      }

      $Config += [PSCustomObject]@{
        Name    = $ConfigName
        APIKey  = $APIKey
        Default = ($Default.IsPresent -or $Config.Count -eq 0)
      }
    }
  }

  End
  {
    If ($Config.Count -gt 0)
    {
      $Config | ForEach-Object {
        $_.APIKey = ConvertTo-SecureString -AsPlainText $_.APIKey -Force
        $_
      } | Export-Clixml -Path $Script:UnifiAPI_Config_Path -Force
    }
  }
}