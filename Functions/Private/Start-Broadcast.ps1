<#
    .SYNOPSIS
    Start a broadcast to the specified devices with the specified webpage.

    .PARAMETER DeviceIds
    An array of device IDs to broadcast to.

    .PARAMETER Webpage
    The URL of the webpage to broadcast.

    .NOTES
    The device IDs can be retrieved using the Get-Resource function with the "devices" resource type.
    WARNING: This is untested.
#>
function Start-Broadcast {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string[]] $DeviceIds,

        [Parameter(Mandatory)]
        [string] $Webpage
    )

    $Headers = @{
        "Content-Type" = "application/json"
    }

    $Parameters = @{
        "deviceIds" = $DeviceIds
        "webpage"   = $Webpage
    }

    return Invoke-Method `
        -Endpoint             "devices/broadcast/webpage" `
        -Method               ([Microsoft.PowerShell.Commands.WebRequestMethod]::Post) `
        -AdditionalHeaders    $Headers `
        -AdditionalParameters $Parameters
}
