<#
    .SYNOPSIS
    A helper function to send a query to the myViewBoard API and return the results.
#>
function Invoke-Method {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $Endpoint,

        [Parameter(Mandatory)]
        [ValidateSet("Get", "Post")]
        [Microsoft.PowerShell.Commands.WebRequestMethod] $Method,

        [Parameter()]
        [hashtable] $AdditionalHeaders,

        [Parameter()]
        [hashtable] $AdditionalParameters
    )

    Assert-Config

    # Base Headers
    $Headers = @{
        "Accept"        = "application/json"
        "Authorization" = "bearer $Script:apiKey"
    }
    foreach ($Key in $AdditionalHeaders.Keys) {
        $Headers[$Key] = $AdditionalHeaders[$Key]
    }

    # Base Parameters
    $Body = @{ "entity_id" = $Script:entity_id }
    foreach ($Key in $AdditionalParameters.Keys) {
        $Body[$Key] = $AdditionalParameters[$Key]
    }

    return Invoke-RestMethod `
        -Uri     "https://oapi.myviewboard.com/$Endpoint" `
        -Headers $Headers `
        -Method  $Method `
        -Body    $Body
}
