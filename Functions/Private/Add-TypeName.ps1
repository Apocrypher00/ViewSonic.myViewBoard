<#
    .SYNOPSIS
    Add a custom type name to the input object based on the MVB Resource type.

    .DESCRIPTION
    This function is used to add a custom type name to the input object based on the MVB Resource type.
    As well as the generic "ViewSonic.myViewBoard.Resource" type name.
    This allows for easier filtering and processing of the objects in later stages of the pipeline.

    .PARAMETER InputObject
    The object to which the custom type name will be added.

    .PARAMETER ResourceType
    The top-level resource associated with the input object.

    .PARAMETER GroupsSubType
    Optional second-level endpoint under groups.

    .PARAMETER DevicesSubType
    Optional second-level endpoint under devices.
#>

function Add-TypeName {
    [CmdletBinding()]
    [OutputType([object])]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [object] $InputObject,

        [Parameter(Mandatory)]
        [MVBResourceType] $ResourceType,

        [Parameter()]
        [MVBGroupsSubType] $GroupsSubType,

        [Parameter()]
        [MVBDevicesSubType] $DevicesSubType
    )
    process {
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

        $TypeName = switch ($Endpoint) {
            "playlists"          { "Playlist" }
            "media"              { "Media" }
            "groups"             { "GroupInfo" }
            "devices"            { "DeviceProfile" }
            "groups/devices"     { "GroupDeviceInfo" }
            "devices/usage"      { "DeviceUsage" }
            "devices/statistics" { "DeviceStatistics" }
            default              { "Unknown" }
        }

        $GenericTypeName  = "ViewSonic.myViewBoard.Resource"
        $SpecificTypeName = "ViewSonic.myViewBoard.$TypeName"

        if (-not $InputObject.PSObject.TypeNames.Contains($GenericTypeName)) {
            $InputObject.PSObject.TypeNames.Insert(0, $GenericTypeName)
        }

        if (-not $InputObject.PSObject.TypeNames.Contains($SpecificTypeName)) {
            $InputObject.PSObject.TypeNames.Insert(0, $SpecificTypeName)
        }

        return $InputObject
    }
}
