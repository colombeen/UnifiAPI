<#
    .SYNOPSIS
      Define connection information

    .DESCRIPTION
      Define connection information: API key

    .PARAMETER APIKey
      The API key that will be used for authentication

    .EXAMPLE
      PS C:\> Set-UIConnection -APIKey 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
      Set the API key from the portal
#>
Function Set-UIConnection
{
  Param
  (
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]
    $APIKey
  )

  Process
  {
    $Script:UnifiAPI_Key = $APIKey

    Get-Variable -Scope Script -Name 'Unifi*' | ForEach-Object { Write-Verbose -Message ('{0} => {1}' -f $_.Name, $_.Value) }
  }
}