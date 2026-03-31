<#
    .SYNOPSIS
    Start a broadcast to the specified devices with the specified webpage.

    .PARAMETER deviceIds
    An array of device IDs to broadcast to.

    .PARAMETER webpage
    The URL of the webpage to broadcast.

    .NOTES
    The device IDs can be retrieved using the Get-MVBResource function with the "devices" resource type.

    !!! We aren't licensed for broadcasting so this doesn't work !!!
#>
function Start-MVBBroadcast {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string[]] $deviceIds,

        [Parameter(Mandatory)]
        [string] $webpage
    )

    # Base parameters
    $BodyParameters = @{
        "entityId"  = $entity_id
        "deviceIds" = $deviceIds
        "webpage"   = $webpage
    } | ConvertTo-Json

    # Common headers for all requests
    $Headers = @{
        "Content-Type"  = "application/json"
        "Accept"        = "application/json"
        "Authorization" = "bearer $apiKey"
    }

    # Build the Uri
    $Uri = "$BaseUrl/devices/broadcast/webpage"

    # Send the query and get the results
    $Results = Invoke-RestMethod `
        -Uri    $Uri `
        -Headers $Headers `
        -Method POST `
        -Body   $BodyParameters

    # Return just the rows of the results, not the metadata
    return $Results
}
