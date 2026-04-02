<#
    .SYNOPSIS
    Retrieve a list of devices from MVB by group.

    .PARAMETER GroupId
    The group_id to filter devices by.

    .PARAMETER Group
    A group object (for example from Get-Group). Its id property is used as group_id.

    .PARAMETER Count
    Optional. The number of results to return per page.
    Default is 100.

    .PARAMETER Page
    Optional. The page number to return.
    Default is 1.

    .NOTES
    The resulting objects aren't equivalent to those returned by Get-Device.
#>
function Get-GroupDevice {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = "Group", ValueFromPipeline)]
        [PSTypeName("ViewSonic.myViewBoard.GroupInfo")] $Group,

        [Parameter(Mandatory, ParameterSetName = "Id")]
        [string] $GroupId,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Count,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Page
    )

    process {
        if ($PSCmdlet.ParameterSetName -eq "Group") { $GroupId = $Group.id }

        $Parameters = @{
            ResourceType    = [MVBResourceType]::groups
            GroupsSubType   = [MVBGroupsSubType]::devices
            QueryParameters = @{ "group_id" = $GroupId }
        }

        if ($PSBoundParameters.ContainsKey("Count")) { $Parameters["Count"] = $Count }
        if ($PSBoundParameters.ContainsKey("Page")) { $Parameters["Page"] = $Page }

        return Get-Resource @Parameters
    }
}