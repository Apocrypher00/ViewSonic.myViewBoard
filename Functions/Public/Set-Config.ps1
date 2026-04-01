<#
    .SYNOPSIS
    Set the required configuration for the module, including the Entity ID and API Key.

    .PARAMETER EntityId
    The Entity ID of your myViewBoard account. This is required to authenticate with the API.

    .PARAMETER ApiKey
    The API Key for your myViewBoard account. This is required to authenticate with the API.
#>
function Set-Config {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $EntityId,

        [Parameter(Mandatory)]
        [string] $ApiKey
    )

    $Script:entity_id = $EntityId
    $Script:apiKey    = $ApiKey
}