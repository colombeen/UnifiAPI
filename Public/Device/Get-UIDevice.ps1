<#
    .SYNOPSIS
      

    .DESCRIPTION
      

    .EXAMPLE
      PS C:\> Get-UIDevice
      Shows stuff

#>
Function Get-UIDevice
{
  [CmdletBinding()]
  Param
  (
    [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $HostId,

    [Parameter(ValueFromPipelineByPropertyName = $true, Position = 1)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Time
  )

  Process
  {
    $URL = '/ea/devices?'
    $Headers = @{}

    If ($null -ne $HostId -and $HostId.Count -gt 0)
    {
      $URL += 'hostIds[]={0}' -f ($HostId -join '&hostIds[]=')
    }

    If ($null -ne $Time)
    {
      # DoStuff
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