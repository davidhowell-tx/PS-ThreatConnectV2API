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
* Get-TCOwners
  * Get-TCOwners
  * Get-TCOwners -IndicatorType Address -Indicator "127.0.0.1"
  * Get-TCOwners -IndicatorType EmailAddress -Indicator "test@baddomain.com"
  * Get-TCOwners -IndicatorType File -Indicator "d41d8cd98f00b204e9800998ecf8427e"
  * Get-TCOwners -IndicatorType Host -Indicator "baddomain.com"
  * Get-TCOwners -IndicatorType URL -Indicator "http://baddomain.com/phishies
* Get-TCAdversaries
  * Get-TCAdversaries
  * Get-TCAdversaries -AdversaryID "123456"
  * Get-TCAdversaries -EmailID "123456"
  * Get-TCAdversaries -IncidentID "123456"
  * Get-TCAdversaries -SecurityLabel "Confidential"
  * Get-TCAdversaries -SignatureID "123456"
  * Get-TCAdversaries -TagName "BadStuff"
  * Get-TCAdversaries -ThreatID "123456"
  * Get-TCAdversaries -VictimID "123456"
  * Get-TCAdversaries -IndicatorType Address -Indicator "127.0.0.1"
  * Get-TCAdversaries -IndicatorType EmailAddress -Indicator "test@baddomain.com"
  * Get-TCAdversaries -IndicatorType File -Indicator "d41d8cd98f00b204e9800998ecf8427e"
  * Get-TCAdversaries -IndicatorType Host -Indicator "baddomain.com"
  * Get-TCAdversaries -IndicatorType URL -Indicator "http://baddomain.com/phishies
* Get-TCGroups
  * Get-TCGroups
  * Get-TCGroups -AdversaryID 123456
  * Get-TCGroups -EmailID "123456"
  * Get-TCGroups -IncidentID "123456"
  * Get-TCGroups -SecurityLabel "Confidential"
  * Get-TCGroups -SignatureID "123456"
  * Get-TCGroups -TagName "BadStuff"
  * Get-TCGroups -ThreatID "123456"
  * Get-TCGroups -VictimID "123456"
* Get-TCAttributes
  * Get-TCAttributes -AdversaryID "123456"
  * Get-TCAttributes -EmailID "123456"
  * Get-TCAttributes -IncidentID "123456"
  * Get-TCAttributes -SignatureID "123456"
  * Get-TCAttributes -ThreatID "123456"
* Get-TCEmails
  * Get-TCEmails
  * Get-TCEmails -AdversaryID "123456"
  * Get-TCEmails -EmailID "123456"
  * Get-TCEmails -IncidentID "123456"
  * Get-TCEmails -SecurityLabel "Confidential"
  * Get-TCEmails -SignatureID "123456"
  * Get-TCEmails -TagName "BadStuff"
  * Get-TCEmails -ThreatID "123456"
  * Get-TCEmails -VictimID "123456"
* Get-TCIncidents
  * Get-TCIncidents
  * Get-TCIncidents -AdversaryID "123456"
  * Get-TCIncidents -EmailID "123456"
  * Get-TCIncidents -IncidentID "123456"
  * Get-TCIncidents -SecurityLabel "Confidential"
  * Get-TCIncidents -SignatureID "123456"
  * Get-TCIncidents -TagName "BadStuff"
  * Get-TCIncidents -ThreatID "123456"
  * Get-TCIncidents -VictimID "123456"
* Get-TCSignatures
  * Get-TCSignatures
  * Get-TCSignatures -AdversaryID "123456"
  * Get-TCSignatures -EmailID "123456"
  * Get-TCSignatures -IncidentID "123456"
  * Get-TCSignatures -SecurityLabel "Confidential"
  * Get-TCSignatures -SignatureID "123456"
  * Get-TCSignatures -TagName "BadStuff"
  * Get-TCSignatures -ThreatID "123456"
  * Get-TCSignatures -VictimID "123456"
* Get-TCThreats
  * Get-TCThreats
  * Get-TCThreats -AdversaryID "123456"
  * Get-TCThreats -EmailID "123456"
  * Get-TCThreats -IncidentID "123456"
  * Get-TCThreats -SecurityLabel "Confidential"
  * Get-TCThreats -SignatureID "123456"
  * Get-TCThreats -TagName "BadStuff"
  * Get-TCThreats -ThreatID "123456"
  * Get-TCThreats -VictimID "123456"
* Get-TCSecurityLabels
  * Get-TCSecurityLabels
  * Get-TCSecurityLabels -AdversaryID 123456
  * Get-TCSecurityLabels -EmailID "123456"
  * Get-TCSecurityLabels -IncidentID "123456"
  * Get-TCSecurityLabels -SecurityLabel "Confidential"
  * Get-TCSecurityLabels -SignatureID "123456"
  * Get-TCSecurityLabels -ThreatID "123456"
  * Get-TCSecurityLabels -IndicatorType Address -Indicator "127.0.0.1"
  * Get-TCSecurityLabels -IndicatorType EmailAddress -Indicator "test@baddomain.com"
  * Get-TCSecurityLabels -IndicatorType File -Indicator "d41d8cd98f00b204e9800998ecf8427e"
  * Get-TCSecurityLabels -IndicatorType Host -Indicator "baddomain.com"
  * Get-TCSecurityLabels -IndicatorType URL -Indicator "http://baddomain.com/phishies
* Get-TCTags
  * Get-TCTags
  * Get-TCTags -AdversaryID 123456
  * Get-TCTags -EmailID "123456"
  * Get-TCTags -IncidentID "123456"
  * Get-TCTags -SignatureID "123456"
  * Get-TCTags -TagName "BadStuff"
  * Get-TCTags -ThreatID "123456"
  * Get-TCTags -IndicatorType Address -Indicator "127.0.0.1"
  * Get-TCTags -IndicatorType EmailAddress -Indicator "test@baddomain.com"
  * Get-TCTags -IndicatorType File -Indicator "d41d8cd98f00b204e9800998ecf8427e"
  * Get-TCTags -IndicatorType Host -Indicator "baddomain.com"
  * Get-TCTags -IndicatorType URL -Indicator "http://baddomain.com/phishies	
* Get-TCVictims
  * Get-TCVictims
  * Get-TCVictims -AdversaryID 123456
  * Get-TCVictims -EmailID "123456"
  * Get-TCVictims -IncidentID "123456"
  * Get-TCVictims -SignatureID "123456"
  * Get-TCVictims -ThreatID "123456"