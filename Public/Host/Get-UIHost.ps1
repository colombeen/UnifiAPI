<#
    .SYNOPSIS
      

    .DESCRIPTION
      

    .EXAMPLE
      PS C:\> Get-UIHost
      Shows stuff

#>
Function Get-UIHost
{
  [CmdletBinding()]
  Param
  ()

  Process
  {
    $URL = '/ea/hosts'
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