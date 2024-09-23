<#
    .SYNOPSIS
      

    .DESCRIPTION
      

    .EXAMPLE
      PS C:\> Get-UISite
      Shows stuff

#>
Function Get-UISite
{
  [CmdletBinding()]
  Param
  ()

  Process
  {
    $URL = '/ea/sites'
    $Headers = @{}

    $InvokeUnifiAPIRequest_Splat = @{
      URI = $URL
    }

    If ($Headers.Count -gt 0)
    {
      $InvokeUnifiAPIRequest_Splat.Add('Headers', $Headers)
    }

    Invoke-UIRequest @InvokeUnifiAPIRequest_Splat
  }
}