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
  (
    [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Id
  )

  Process
  {
    $URL = '/ea/hosts'
    $Headers = @{}

    If ($null -ne $Id)
    {
      $URL += '/{0}' -f $Id
    }

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