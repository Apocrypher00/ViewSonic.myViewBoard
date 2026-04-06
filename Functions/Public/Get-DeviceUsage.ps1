<#
    .SYNOPSIS
    Retrieve a list of device usage data from MVB.

    .PARAMETER GroupId
    The group_id to filter by.

    .PARAMETER Group
    The Group object(s) to filter devices by.

    .PARAMETER DeviceId
    The device_id to filter by.

    .PARAMETER Device
    The Device object(s) to filter by.

    .PARAMETER GroupDevice
    The GroupDevice object(s) to filter by.

    .PARAMETER StartTime
    Optional. The start time of the time period.
    Accepts values convertible to DateTimeOffset and is sent to the API as Unix time in milliseconds.

    .PARAMETER EndTime
    Optional. The end time of the time period.
    Accepts values convertible to DateTimeOffset and is sent to the API as Unix time in milliseconds.

    .PARAMETER Count
    Optional. The number of results to return per page.
    Default is 100.

    .PARAMETER Page
    Optional. The page number to return.
    Default is 1.
#>
function Get-DeviceUsage {
    [CmdletBinding(DefaultParameterSetName = "GroupId")]
    param (
        [Parameter(ParameterSetName = "Device", ValueFromPipeline)]
        [PSTypeName("ViewSonic.myViewBoard.DeviceProfile")]
        [object[]] $Device,

        [Parameter(ParameterSetName = "GroupDevice", ValueFromPipeline)]
        [PSTypeName("ViewSonic.myViewBoard.GroupDeviceInfo")]
        [object[]] $GroupDevice,

        [Parameter(ParameterSetName = "DeviceId")]
        [string[]] $DeviceId,

        [Parameter(ParameterSetName = "Group", ValueFromPipeline)]
        [PSTypeName("ViewSonic.myViewBoard.GroupInfo")]
        [object[]] $Group,

        [Parameter(ParameterSetName = "GroupId")]
        [string[]] $GroupId,

        [Parameter()]
        [datetimeoffset] $StartTime,

        [Parameter()]
        [datetimeoffset] $EndTime,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Count,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Page
    )

    process {
        $ResolvedId = @()
        $QueryKey = $null

        switch ($PSCmdlet.ParameterSetName) {
            "Group" {
                $QueryKey = "group_id"
                if ($null -ne $Group -and $null -ne $Group.id) {
                    $ResolvedId += $Group.id
                }
            }
            "GroupId" {
                $QueryKey = "group_id"
                if ($PSBoundParameters.ContainsKey("GroupId")) {
                    $ResolvedId += $GroupId
                }
            }
            "Device" {
                $QueryKey = "device_id"
                if ($null -ne $Device -and $null -ne $Device.id) {
                    $ResolvedId += $Device.id
                }
            }
            "GroupDevice" {
                $QueryKey = "device_id"
                if ($null -ne $GroupDevice -and $null -ne $GroupDevice.id) {
                    $ResolvedId += $GroupDevice.id
                }
            }
            "DeviceId" {
                $QueryKey = "device_id"
                if ($PSBoundParameters.ContainsKey("DeviceId")) {
                    $ResolvedId += $DeviceId
                }
            }
        }

        if (
            $PSBoundParameters.ContainsKey("StartTime") -and
            $PSBoundParameters.ContainsKey("EndTime") -and
            $StartTime -gt $EndTime
        ) {
            throw "StartTime cannot be greater than EndTime."
        }

        $QueryParameters = @{}

        if ($ResolvedId.Count -gt 0 -and -not [string]::IsNullOrWhiteSpace($QueryKey)) {
            $QueryParameters[$QueryKey] = ($ResolvedId -join ",")
        }

        if ($PSBoundParameters.ContainsKey("StartTime")) {
            $QueryParameters["start_time"] = $StartTime.ToUnixTimeMilliseconds()
        }

        if ($PSBoundParameters.ContainsKey("EndTime")) {
            $QueryParameters["end_time"] = $EndTime.ToUnixTimeMilliseconds()
        }

        $Parameters = @{
            ResourceType   = [MVBResourceType]::devices
            DevicesSubType = [MVBDevicesSubType]::usage
        }

        if ($QueryParameters.Count -gt 0) {
            $Parameters["QueryParameters"] = $QueryParameters
        }

        if ($PSBoundParameters.ContainsKey("Count")) { $Parameters["Count"] = $Count }
        if ($PSBoundParameters.ContainsKey("Page")) { $Parameters["Page"] = $Page }

        return Get-Resource @Parameters
    }
}
