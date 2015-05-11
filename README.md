# PS-ThreatConnectV2API
PS-ThreatConnectV2API is my attempt to write a PowerShell Module that interfaces with the Threat Connect Version 2 API.

At this time I have performed limited testing with some of these commands, but not all of them.  Some of these commands are just written using the information in the API Documentation and have not been tested. If you find any issues, please either point them out so I can find time to fix it, or if you want provide a fix.

# Instructions
1. Modify lines 2, 3, and 4 with your Access ID, Secret Key, and Default Organization. Use single quotes in order to avoid any issues with special characters like $.

  * You can edit using Notepad or PowerShell ISE. 

2. Execute PowerShell

  * If you aren't a normal PowerShell user, be sure you've run `Set-ExecutionPolicy Unrestricted`.  This will allow you to run PowerShell commands.  Doing so will not expose you to any additional risk, as Execution Policies are poor at best.

3. Import the ThreatConnectV2API module by substituting the full path in the following command: `Import-Module C:\ThreatConnectV2API.psm1`

  * As an alternative you can copy the module files to `C:\Users\youusername\WindowsPowerShell\Modules\ThreatConnectV2API.psm1` and afterwards use `Import-Module ThreatConnectV2API`

4. Take a look at the available commands by running `Get-Command -Module ThreatConnectV2API`

5. Get more information about specific commands by running `Get-Help <COMMAND NAME HERE>`

  * For Example `Get-Help Get-TCOwners`

# Requirements
* Powershell Version 3
`.NET Framework v4 may also be required, but unsure`

# Available Commands
`Note: -Owner switch can be used to specify the "owner" to query (Common Community, Subscriber Community, etc.).`
`Note: -ResultLimit switch can be used to specify number of results to return. Default is 100, Maximum is 500.`
`Note: -ResultStart switch can be used with large number of results to start listing results at a numbered offset (example: list 100 results starting at 100, or 100 through 200).`
`-Owner, -ResultLimit, and -ResultStart switches can be used in most of the commands, alongside many of the other switches.`
* Get-TCOwners
* Get-TCAdversaries
* Get-TCGroups
* Get-TCAttributes
* Get-TCEmails
* Get-TCIncidents
* Get-TCIndicators
* Get-TCSignatures
* Get-TCThreats
* Get-TCSecurityLabels
* Get-TCTags
* Get-TCVictims
* Get-TCVictimAssets
* New-TCAdversary
* New-TCIncident
* New-TCThreat
* New-TCAttribute
* Set-TCAttribute