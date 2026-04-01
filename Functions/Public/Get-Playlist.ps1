<#
    .SYNOPSIS
    Retrieve a list of playlists from MVB.

    .PARAMETER Count
    Optional. The number of results to return per page.
    Default is 100.

    .PARAMETER Page
    Optional. The page number to return.
    Default is 1.

    .NOTES
    WARNING: This is untested.
#>
function Get-Playlist {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Count,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Page
    )

    $Parameters = @{ ResourceType = [MVBResourceType]::playlists }
    if ($PSBoundParameters.ContainsKey("Count")) { $Parameters["Count"] = $Count }
    if ($PSBoundParameters.ContainsKey("Page")) { $Parameters["Page"] = $Page }

    return Get-Resource @Parameters
}
