<#
    .SYNOPSIS
    Assert that the configuration has been set before allowing any API calls to be made.
#>
function Assert-Config {
    [CmdletBinding()]
    param ()

    if ((-not $Script:entity_id) -or (-not $Script:apiKey)) {
        throw "Configuration not set. Please run Set-Config to set the Entity ID and API Key."
    }
}