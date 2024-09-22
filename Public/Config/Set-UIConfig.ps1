<#
    .SYNOPSIS
      Update connection information in the Unifi API config file

    .DESCRIPTION
      Update connection information in the config file for Unifi API

    .PARAMETER Name
      The current name for this specific config information

    .PARAMETER NewName
      The new name for this specific config information

    .PARAMETER APIKey
      The API key that will be used for authentication

    .PARAMETER Default
      Set this config information as the default one used by the module

    .EXAMPLE
      PS C:\> Set-UIConfig -Name 'Company' -NewName 'Company 2' -Default
      Update the config information for 'Company' and rename it to 'Company 2' in the Unifi API config file and make it the default config when the module gets loaded

    .EXAMPLE
      PS C:\> Set-UIConfig -Name 'Company 2' -APIKey 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
      Update the config information for 'Company 2' in the Unifi API config file with a new API key
#>
Function Set-UIConfig
{
  [CmdletBinding(ConfirmImpact = 'High', SupportsShouldProcess = $true)]
  Param
  (
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Name,

    [Parameter(Position = 1)]
    [ValidateNotNullOrEmpty()]
    [string]
    $NewName,

    [Parameter(Position = 2)]
    [ValidateNotNullOrEmpty()]
    [string]
    $APIKey,

    [Parameter(Position = 3)]
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

    If ($ConfigName -in $Config.Name)
    {
      If ($PSCmdlet.ShouldProcess($ConfigName, 'Set'))
      {
        If ($Default.IsPresent)
        {
          $Config | ForEach-Object {
            $_.Default = $false
          }
        }

        $Config | Where-Object {
          $_.Name -eq $ConfigName
        } | ForEach-Object {
          If ($PSBoundParameters.ContainsKey('NewName'))
          {
            If ($NewName -in $Config.Name)
            {
              Throw ('Can''t change the name of {0} to {1} because it is already in use' -f $ConfigName, $NewName)
            }

            $_.Name = $NewName
          }
          If ($PSBoundParameters.ContainsKey('APIKey'))
          {
            $_.APIKey = $APIKey
          }
          If ($Default.IsPresent)
          {
            $_.Default = $true
          }
        }
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