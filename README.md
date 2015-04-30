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

  * For Example `Get-Help Get-Owners`

# Available Commands
`Note: -Owner switch can be used alongside many other switches. I have not included documentation on when it is available.`
* Get-Owners
* Get-Adversaries
  * Get-Adversaries
  * Get-Adversaries -AdversaryID "123456"
  * Get-Adversaries -EmailID "123456"
  * Get-Adversaries -IncidentID "123456"
  * Get-Adversaries -SecurityLabel "Confidential"
  * Get-Adversaries -SignatureID "123456"
  * Get-Adversaries -TagName "BadStuff"
  * Get-Adversaries -ThreatID "123456"
  * Get-Adversaries -VictimID "123456"
* Get-Attributes
  * Get-Attributes -AdversaryID "123456"
  * Get-Attributes -EmailID "123456"
  * Get-Attributes -IncidentID "123456"
  * Get-Attributes -SignatureID "123456"
  * Get-Attributes -ThreatID "123456"
* Get-Emails
  * Get-Emails
  * Get-Emails -AdversaryID "123456"
  * Get-Emails -EmailID "123456"
  * Get-Emails -IncidentID "123456"
  * Get-Emails -SecurityLabel "Confidential"
  * Get-Emails -SignatureID "123456"
  * Get-Emails -TagName "BadStuff"
  * Get-Emails -ThreatID "123456"
  * Get-Emails -VictimID "123456"
* Get-Incidents
  * Get-Incidents
  * Get-Incidents -AdversaryID "123456"
  * Get-Incidents -EmailID "123456"
  * Get-Incidents -IncidentID "123456"
  * Get-Incidents -SecurityLabel "Confidential"
  * Get-Incidents -SignatureID "123456"
  * Get-Incidents -TagName "BadStuff"
  * Get-Incidents -ThreatID "123456"
  * Get-Incidents -VictimID "123456"
* Get-Signatures
  * Get-Signatures
  * Get-Signatures -AdversaryID "123456"
  * Get-Signatures -EmailID "123456"
  * Get-Signatures -IncidentID "123456"
  * Get-Signatures -SecurityLabel "Confidential"
  * Get-Signatures -SignatureID "123456"
  * Get-Signatures -TagName "BadStuff"
  * Get-Signatures -ThreatID "123456"
  * Get-Signatures -VictimID "123456"
* Get-Threats
  * Get-Threats
  * Get-Threats -AdversaryID "123456"
  * Get-Threats -EmailID "123456"
  * Get-Threats -IncidentID "123456"
  * Get-Threats -SecurityLabel "Confidential"
  * Get-Threats -SignatureID "123456"
  * Get-Threats -TagName "BadStuff"
  * Get-Threats -ThreatID "123456"
  * Get-Threats -VictimID "123456"
* Get-SecurityLabels
  * Get-SecurityLabels
  * Get-SecurityLabels -AdversaryID 123456
  * Get-SecurityLabels -EmailID "123456"
  * Get-SecurityLabels -IncidentID "123456"
  * Get-SecurityLabels -SecurityLabel "Confidential"
  * Get-SecurityLabels -SignatureID "123456"
  * Get-SecurityLabels -ThreatID "123456"
* Get-Tags
  * Get-Tags
  * Get-Tags -AdversaryID 123456
  * Get-Tags -EmailID "123456"
  * Get-Tags -IncidentID "123456"
  * Get-Tags -SignatureID "123456"
  * Get-Tags -TagName "BadStuff"
  * Get-Tags -ThreatID "123456"
* Get-Victims
  * Get-Victims
  * Get-Victims -AdversaryID 123456
  * Get-Victims -EmailID "123456"
  * Get-Victims -IncidentID "123456"
  * Get-Victims -SignatureID "123456"
  * Get-Victims -ThreatID "123456"