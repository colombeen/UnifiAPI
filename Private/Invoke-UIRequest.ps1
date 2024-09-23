<#
    .SYNOPSIS
      Query the API

    .DESCRIPTION
      Query the API service from Unifi API

    .PARAMETER URI
      The specific URI that you want to target

    .PARAMETER Method
      The rest method required for the query (GET, POST, PUT, DELETE, ...)

    .PARAMETER Body
      The body that accompanies the POST method query

    .PARAMETER Headers
      The headers required to authenticate, enrich or filter the query

    .PARAMETER Timeout
      The timeout setting for retrieving data from the API

    .EXAMPLE
      PS C:\> Invoke-UIRequest -URI '/ea/hosts' -Method 'Get'
#>
Function Invoke-UIRequest
{
  [CmdletBinding()]
  Param
  (
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]
    $URI,

    [Parameter(ValueFromPipelineByPropertyName = $true, Position = 1)]
    [ValidateNotNullOrEmpty()]
    [Microsoft.PowerShell.Commands.WebRequestMethod]
    $Method = 'Get',

    [Parameter(ValueFromPipelineByPropertyName = $true, Position = 2)]
    [ValidateNotNullOrEmpty()]
    [object]
    $Body,

    [Parameter(ValueFromPipelineByPropertyName = $true, Position = 3)]
    [ValidateNotNullOrEmpty()]
    [hashtable]
    $Headers,

    [Parameter(ValueFromPipelineByPropertyName = $true, Position = 4)]
    [ValidateNotNullOrEmpty()]
    [int32]
    $Timeout = 0
  )

  Process
  {
    #region Connection Requirements
    If ($null -eq $Script:UnifiAPI_Key)
    {
      Throw 'Missing connection information. You need to setup the connection settings first by using the Set-UIConnection function or store the connection information by using the Add-UIConfig function.'
    }

    If ($PSBoundParameters.ContainsKey('Headers'))
    {
      If (-not $Headers.ContainsKey('Accept'))
      {
        $Headers.Add('Accept', 'application/json')
      }
      If (-not $Headers.ContainsKey('X-API-KEY'))
      {
        $Headers.Add('X-API-KEY', $Script:UnifiAPI_key)
      }
    }
    Else
    {
      $Headers = @{
        'Accept'    = 'application/json'
        'X-API-KEY' = $Script:UnifiAPI_key
      }
    }
    #endregion

    #region Verbose headers
    $Headers.GetEnumerator() | ForEach-Object { Write-Verbose -Message ('{0} => {1}' -f $_.Key, $_.Value) }
    #endregion

    #region Splat
    $UnifiAPI_InvokeRestMethod_Splat = @{
      Method     = $Method
      Headers    = $Headers
      TimeoutSec = $Timeout
      URI        = $Script:UnifiAPI_URL + $URI
    }
    #endregion

    #region Body check
    If ($PSBoundParameters.ContainsKey('Body'))
    {
      $UnifiAPI_InvokeRestMethod_Splat.Add('Body', $Body)
    }
    #endregion

    #region Query API
    Try
    {
      $Result = Invoke-RestMethod @UnifiAPI_InvokeRestMethod_Splat
      $Result.data
    }
    Catch
    {
      $_.ErrorDetails.Message | ConvertFrom-Json
    }
    #endregion
  }
}