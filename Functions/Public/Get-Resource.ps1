<#
    .SYNOPSIS
    Query the myViewBoard API via REST GET.

    .PARAMETER ResourceType
    The top-level resource to query.
    Valid values are: playlists, media, groups, devices.

    .PARAMETER GroupsSubType
    Optional second-level endpoint under groups.

    .PARAMETER DevicesSubType
    Optional second-level endpoint under devices.

    .PARAMETER QueryParameters
    Optional endpoint-specific query parameters.

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
        [MVBGroupsSubType] $GroupsSubType,

        [Parameter()]
        [MVBDevicesSubType] $DevicesSubType,

        [Parameter()]
        [hashtable] $QueryParameters,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Count,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Page
    )

    if ($PSBoundParameters.ContainsKey("GroupsSubType") -and $ResourceType -ne [MVBResourceType]::groups) {
        throw "GroupsSubType can only be used when ResourceType is 'groups'."
    }

    if ($PSBoundParameters.ContainsKey("DevicesSubType") -and $ResourceType -ne [MVBResourceType]::devices) {
        throw "DevicesSubType can only be used when ResourceType is 'devices'."
    }

    $Endpoint = [string]$ResourceType
    if ($PSBoundParameters.ContainsKey("GroupsSubType")) {
        $Endpoint = "$Endpoint/$GroupsSubType"
    }
    elseif ($PSBoundParameters.ContainsKey("DevicesSubType")) {
        $Endpoint = "$Endpoint/$DevicesSubType"
    }

    $Parameters = @{}
    if ($PSBoundParameters.ContainsKey("Count")) { $Parameters["count"] = $Count }
    if ($PSBoundParameters.ContainsKey("Page")) { $Parameters["page"] = $Page }
    if ($PSBoundParameters.ContainsKey("QueryParameters")) {
        foreach ($Key in $QueryParameters.Keys) {
            $Parameters[$Key] = $QueryParameters[$Key]
        }
    }

    # Send the query and get the results.
    $Results = Invoke-Method `
        -Endpoint             $Endpoint `
        -Method               ([Microsoft.PowerShell.Commands.WebRequestMethod]::Get) `
        -AdditionalParameters $Parameters

    $TypeNameParameters = @{ ResourceType = $ResourceType }
    if ($PSBoundParameters.ContainsKey("GroupsSubType")) { $TypeNameParameters["GroupsSubType"] = $GroupsSubType }
    if ($PSBoundParameters.ContainsKey("DevicesSubType")) { $TypeNameParameters["DevicesSubType"] = $DevicesSubType }

    # Add schema-based type names for downstream formatting and filtering
    $Results.rows | Add-TypeName @TypeNameParameters | Out-Null

    # Return just the array of results, not the full response object with metadata
    return $Results.rows
}
