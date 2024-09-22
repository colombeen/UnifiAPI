#region Variables
New-Variable -Scope Script -Visibility Private -Force -Name 'UnifiAPI_Key' -Value $null
New-Variable -Scope Script -Visibility Private -Force -Name 'UnifiAPI_URL' -Value 'https://api.ui.com'
New-Variable -Scope Script -Visibility Private -Force -Name 'UnifiAPI_Config_Path' -Value $null
#endregion

#region Load function files
Foreach ($Folder in @('Private', 'Public'))
{
  $FolderPath = Join-Path -Path $PSScriptRoot -ChildPath $Folder

  If (Test-Path -Path $FolderPath)
  {
    $Functions = Get-ChildItem -Path $FolderPath -Filter *.ps1 -Recurse

    Foreach ($Function in $Functions)
    {
      . $Function.FullName

      If ($Folder -notin @('Interal', 'Private'))
      {
        Export-ModuleMember -Function $Function.BaseName
      }
    }
  }
}
#endregion

#region Init default config
Assert-UIConfig

Try
{
  Select-UIConfig
}
Catch
{
  Write-Verbose $_
}
#endregion