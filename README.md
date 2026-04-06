# ViewSonic.myViewBoard

PowerShell module for the ViewSonic myViewBoard REST API.

This module provides a PowerShell interface for querying
devices, groups, media, playlists, device usage, and device statistics from myViewBoard.

## Requirements

- PowerShell 5.1 or PowerShell 7+
- A myViewBoard `entity_id`
- A myViewBoard API key

## Installation

Install from the PowerShell Gallery:

```powershell
Install-Module ViewSonic.myViewBoard
```

If you want the module only for the current user:

```powershell
Install-Module ViewSonic.myViewBoard -Scope CurrentUser
```

Import the module:

```powershell
Import-Module ViewSonic.myViewBoard
```

Because the module manifest sets `DefaultCommandPrefix = 'MVB'`, the imported command names are prefixed automatically.
For example, `Get-Device` is available as `Get-MVBDevice` after import.

## Configuration

Before making API calls, store your myViewBoard credentials in the module session:

```powershell
Set-MVBConfig -EntityId 'your-entity-id' -ApiKey 'your-api-key'
```

The configuration is stored in script scope for the current PowerShell session.
If you open a new session, run `Set-MVBConfig` again.

## Exported Commands

- `Set-MVBConfig`
- `Get-MVBDevice`
- `Get-MVBDeviceStatistics`
- `Get-MVBDeviceUsage`
- `Get-MVBGroup`
- `Get-MVBGroupDevice`
- `Get-MVBMedia`
- `Get-MVBPlaylist`
- `Get-MVBResource`
- `Invoke-MVBMethod`

## Common Usage

List devices:

```powershell
Get-MVBDevice
```

List groups:

```powershell
Get-MVBGroup
```

Get devices from a specific group:

```powershell
Get-MVBGroupDevice -GroupId 'group-id'
```

Get devices from group objects in the pipeline:

```powershell
Get-MVBGroup | Get-MVBGroupDevice
```

Get device statistics for a single device:

```powershell
Get-MVBDeviceStatistics -DeviceId 'device-id'
```

Get device statistics for all devices in a group:

```powershell
Get-MVBGroup -Count 1 | Get-MVBDeviceStatistics
```

Get device usage for a time window:

```powershell
$start = (Get-Date).AddDays(-7)
$end = Get-Date

Get-MVBDeviceUsage -StartTime $start -EndTime $end
```

Get usage for one device:

```powershell
Get-MVBDeviceUsage -DeviceId 'device-id' -StartTime (Get-Date).AddDays(-30) -EndTime (Get-Date)
```

List media:

```powershell
Get-MVBMedia
```

List playlists:

```powershell
Get-MVBPlaylist
```

## Pagination

Endpoints that return lists support `-Count` and `-Page`.

```powershell
Get-MVBDevice -Count 100 -Page 2
```

The module passes these values directly to the API.
If you need all results, iterate over pages until the API returns no more rows.

## Advanced Queries

`Get-MVBResource` is the generic query function used by the higher-level commands.

Get all devices through the generic resource endpoint:

```powershell
Get-MVBResource -ResourceType devices
```

Get device usage directly:

```powershell
Get-MVBResource -ResourceType devices -DevicesSubType usage
```

Get group devices directly:

```powershell
Get-MVBResource -ResourceType groups -GroupsSubType devices -QueryParameters @{ group_id = 'group-id' }
```

`Invoke-MVBMethod` is the lowest-level public function and lets you
call the API directly when you need functionality that is not wrapped yet.

```powershell
Invoke-MVBMethod -Endpoint 'devices' -Method Get
```

## Output Types

Returned objects are decorated with custom type names so PowerShell can
apply formatting and make pipeline scenarios easier to work with.

Examples include:

- `ViewSonic.myViewBoard.DeviceProfile`
- `ViewSonic.myViewBoard.DeviceStatistics`
- `ViewSonic.myViewBoard.DeviceUsage`
- `ViewSonic.myViewBoard.GroupInfo`
- `ViewSonic.myViewBoard.GroupDeviceInfo`
- `ViewSonic.myViewBoard.Media`
- `ViewSonic.myViewBoard.Playlist`

That type information is what allows commands such as
`Get-MVBGroup | Get-MVBGroupDevice` and `Get-MVBDevice | Get-MVBDeviceStatistics` to work naturally.

## Notes

- The API documentation for myViewBoard is available at <https://oapi-doc.myviewboard.com/#myviewboard-open-api-doc>
- Authentication state is held only in memory for the current session
- `Invoke-MVBMethod` sends the configured `entity_id` and `APIKey` automatically with each request

## Example Session

```powershell
Import-Module ViewSonic.myViewBoard

Set-MVBConfig -EntityId 'your-entity-id' -ApiKey 'your-api-key'

$groups = Get-MVBGroup
$devices = $groups | Select-Object -First 1 | Get-MVBGroupDevice
$stats = $devices | Get-MVBDeviceStatistics
$usage = $devices | Get-MVBDeviceUsage -StartTime (Get-Date).AddDays(-7) -EndTime (Get-Date)

$groups
$devices
$stats
$usage
```
