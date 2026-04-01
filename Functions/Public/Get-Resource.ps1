<#
    .SYNOPSIS
    Query the myViewBoard API via REST GET

    .PARAMETER ResourceType
    The type of resource to query.
    Valid values are: playlists, media, groups, devices

    .PARAMETER Count
    Optional. The number of results to return per page.
    Default is 100.

    .PARAMETER Page
    Optional. The page number to return.
    Default is 1.
#>
function Get-Resource {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [MVBResourceType] $ResourceType,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Count,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Page
    )

    $Parameters = @{}
    if ($PSBoundParameters.ContainsKey("Count")) { $Parameters["count"] = $Count }
    if ($PSBoundParameters.ContainsKey("Page")) { $Parameters["page"] = $Page }

    # Send the query and get the results
    $Results = Invoke-Method `
        -Endpoint             $ResourceType `
        -Method               ([Microsoft.PowerShell.Commands.WebRequestMethod]::Get) `
        -AdditionalParameters $Parameters

    # Return just the rows of the results, not the metadata
    return $Results.rows
}
