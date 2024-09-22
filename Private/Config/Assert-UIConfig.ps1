<#
    .SYNOPSIS
      Assert the UnfiAPI config file

    .DESCRIPTION
      Assert the config file for communication with the Unifi API

    .EXAMPLE
      PS C:\> Assert-UIConfig
#>
Function Assert-UIConfig
{
  Process
  {
    $Path = [Environment]::GetFolderPath([Environment+SpecialFolder]::LocalApplicationData)

    'UnifiAPI', 'PowerShell' | ForEach-Object {
      $Path = Join-Path -Path $Path -ChildPath $_
    }

    If (-not (Test-Path -Path $Path -ErrorAction SilentlyContinue))
    {
      New-Item -Path $Path -ItemType Directory -Force | Out-Null
    }

    $Path = Join-Path -Path $Path -ChildPath 'config.xml'

    If (-not (Test-Path -Path $Path -ErrorAction SilentlyContinue))
    {
      New-Item -Path $Path -ItemType File -Force | Out-Null
    }

    If (Test-Path -Path $Path -ErrorAction SilentlyContinue)
    {
      $Script:UnifiAPI_Config_Path = $Path
    }
  }
}