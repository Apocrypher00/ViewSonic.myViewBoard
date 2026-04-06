<#
    .SYNOPSIS
    Retrieve a list of multimedia from MVB.

    .PARAMETER Count
    Optional. The number of results to return per page.
    Default is 100.

    .PARAMETER Page
    Optional. The page number to return.
    Default is 1.
#>
function Get-Media {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Count,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Page
    )

    $Parameters = @{ ResourceType = [MVBResourceType]::media }
    if ($PSBoundParameters.ContainsKey("Count")) { $Parameters["Count"] = $Count }
    if ($PSBoundParameters.ContainsKey("Page")) { $Parameters["Page"] = $Page }

    return Get-Resource @Parameters
}
