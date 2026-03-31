<#
    .SYNOPSIS
    Query the myViewBoard API via REST GET

    .PARAMETER ResourceType
    The type of resource to query. Valid values are: playlists, media, groups, devices

    .PARAMETER count
    Optional. The number of results to return per page.
    Default is 100.

    .PARAMETER page
    Optional. The page number to return.
    Default is 1.
#>
function Get-MVBResource {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ResourceType] $ResourceType,

        [Parameter()]
        [int] $count,

        [Parameter()]
        [int] $page
    )

    # Base parameters
    $QueryParameters = @{ "entity_id" = $entity_id }

    # Other standard parameters
    if ($count) { $QueryParameters["count"] = $count }
    if ($page) { $QueryParameters["page"] = $page }

    # Common headers for all requests
    $Headers = @{
        "Accept"        = "application/json"
        "Authorization" = "bearer $apiKey"
    }

    # Build the Uri
    $Uri = "$BaseUrl/$ResourceType"

    # Send the query and get the results
    $Results = Invoke-RestMethod `
        -Uri    $Uri `
        -Headers $Headers `
        -Method Get `
        -Body   $QueryParameters

    # Return just the rows of the results, not the metadata
    return $Results.rows
}
