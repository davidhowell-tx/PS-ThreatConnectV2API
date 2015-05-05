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

# Available Commands
`Note: -Owner switch can be used alongside many other switches. I have not included documentation on when it is available.`
* Get-TCOwners
  * Get-TCOwners
  * Get-TCOwners -IndicatorType Address -Indicator <Indicator>
  * Get-TCOwners -IndicatorType EmailAddress -Indicator <Indicator>
  * Get-TCOwners -IndicatorType File -Indicator <Indicator>
  * Get-TCOwners -IndicatorType Host -Indicator <Indicator>
  * Get-TCOwners -IndicatorType URL -Indicator <Indicator>
* Get-TCAdversaries
  * Get-TCAdversaries
  * Get-TCAdversaries -AdversaryID <AdversaryID>
  * Get-TCAdversaries -EmailID <EmailID>
  * Get-TCAdversaries -IncidentID <IncidentID>
  * Get-TCAdversaries -SecurityLabel <SecurityLabel>
  * Get-TCAdversaries -SignatureID <SignatureID>
  * Get-TCAdversaries -TagName <TagName>
  * Get-TCAdversaries -ThreatID <ThreatID>
  * Get-TCAdversaries -VictimID <VictimID>
  * Get-TCAdversaries -IndicatorType Address -Indicator <Indicator>
  * Get-TCAdversaries -IndicatorType EmailAddress -Indicator <Indicator>
  * Get-TCAdversaries -IndicatorType File -Indicator <Indicator>
  * Get-TCAdversaries -IndicatorType Host -Indicator <Indicator>'
  * Get-TCAdversaries -IndicatorType URL -Indicator <Indicator>
* Get-TCGroups
  * Get-TCGroups
  * Get-TCGroups -AdversaryID <AdversaryID>
  * Get-TCGroups -EmailID <EmailID>
  * Get-TCGroups -IncidentID <IncidentID>
  * Get-TCGroups -SecurityLabel <SecurityLabel>
  * Get-TCGroups -SignatureID <SignatureID>
  * Get-TCGroups -TagName <TagName>
  * Get-TCGroups -ThreatID <ThreatID>
  * Get-TCGroups -VictimID <VictimID>
  * Get-TCGroups -IndicatorType Address -Indicator <Indicator>
  * Get-TCGroups -IndicatorType EmailAddress -Indicator <Indicator>
  * Get-TCGroups -IndicatorType File -Indicator <Indicator>
  * Get-TCGroups -IndicatorType Host -Indicator <Indicator>
  * Get-TCGroups -IndicatorType URL -Indicator <Indicator>
* Get-TCAttributes
  * Get-TCAttributes -AdversaryID <AdversaryID>
  * Get-TCAttributes -EmailID <EmailID>
  * Get-TCAttributes -IncidentID <IncidentID>
  * Get-TCAttributes -SignatureID <SignatureID>
  * Get-TCAttributes -ThreatID <ThreatID>
  * Get-TCAttributes -IndicatorType Address -Indicator <Indicator>
  * Get-TCAttributes -IndicatorType EmailAddress -Indicator <Indicator>
  * Get-TCAttributes -IndicatorType File -Indicator <Indicator>
  * Get-TCAttributes -IndicatorType Host -Indicator <Indicator>
  * Get-TCAttributes -IndicatorType URL -Indicator <Indicator>
* Get-TCEmails
  * Get-TCEmails
  * Get-TCEmails -AdversaryID <AdversaryID>
  * Get-TCEmails -EmailID <EmailID>
  * Get-TCEmails -IncidentID <IncidentID>
  * Get-TCEmails -SecurityLabel <SecurityLabel>
  * Get-TCEmails -SignatureID <SignatureID>
  * Get-TCEmails -TagName <TagName>
  * Get-TCEmails -ThreatID <ThreatID>
  * Get-TCEmails -VictimID <VictimID>
  * Get-TCEmails -IndicatorType Address -Indicator <Indicator>
  * Get-TCEmails -IndicatorType EmailAddress -Indicator <Indicator>
  * Get-TCEmails -IndicatorType File -Indicator <Indicator>
  * Get-TCEmails -IndicatorType Host -Indicator <Indicator>
  * Get-TCEmails -IndicatorType URL -Indicator <Indicator>
* Get-TCIncidents
  * Get-TCIncidents
  * Get-TCIncidents -AdversaryID <AdversaryID>
  * Get-TCIncidents -EmailID <EmailID>
  * Get-TCIncidents -IncidentID <IncidentID>
  * Get-TCIncidents -SecurityLabel <SecurityLabel>
  * Get-TCIncidents -SignatureID <SignatureID>
  * Get-TCIncidents -TagName <TagName>
  * Get-TCIncidents -ThreatID <ThreatID>
  * Get-TCIncidents -VictimID <VictimID>
  * Get-TCIncidents -IndicatorType Address -Indicator <Indicator>
  * Get-TCIncidents -IndicatorType EmailAddress -Indicator <Indicator>
  * Get-TCIncidents -IndicatorType File -Indicator <Indicator>
  * Get-TCIncidents -IndicatorType Host -Indicator <Indicator>
  * Get-TCIncidents -IndicatorType URL -Indicator <Indicator>
* Get-TCIndicators
  * Get-TCIndicators
  * Get-TCIndicators -AdversaryID <AdversaryID>
  * Get-TCIndicators -EmailID <EmailID>
  * Get-TCIndicators -IncidentID <IncidentID>
  * Get-TCIndicators -SecurityLabel <SecurityLabel>
  * Get-TCIndicators -SignatureID <SignatureID>
  * Get-TCIndicators -TagName <TagName>
  * Get-TCIndicators -ThreatID <ThreatID>
  * Get-TCIndicators -VictimID <VictimID>
* Get-TCSignatures
  * Get-TCSignatures
  * Get-TCSignatures -AdversaryID <AdversaryID>
  * Get-TCSignatures -EmailID <EmailID>
  * Get-TCSignatures -IncidentID <IncidentID>
  * Get-TCSignatures -SecurityLabel <SecurityLabel>
  * Get-TCSignatures -SignatureID <SignatureID>
  * Get-TCSignatures -TagName <TagName>
  * Get-TCSignatures -ThreatID <ThreatID>
  * Get-TCSignatures -VictimID <VictimID>
  * Get-TCSignatures -IndicatorType Address -Indicator <Indicator>
  * Get-TCSignatures -IndicatorType EmailAddress -Indicator <Indicator>
  * Get-TCSignatures -IndicatorType File -Indicator <Indicator>
  * Get-TCSignatures -IndicatorType Host -Indicator <Indicator>
  * Get-TCSignatures -IndicatorType URL -Indicator <Indicator>
* Get-TCThreats
  * Get-TCThreats
  * Get-TCThreats -AdversaryID <AdversaryID>
  * Get-TCThreats -EmailID <EmailID>
  * Get-TCThreats -IncidentID <IncidentID>
  * Get-TCThreats -SecurityLabel <SecurityLabel>
  * Get-TCThreats -SignatureID <SignatureID>
  * Get-TCThreats -TagName <TagName>
  * Get-TCThreats -ThreatID <ThreatID>
  * Get-TCThreats -VictimID <VictimID>
  * Get-TCThreats -IndicatorType Address -Indicator <Indicator>
  * Get-TCThreats -IndicatorType EmailAddress -Indicator <Indicator>
  * Get-TCThreats -IndicatorType File -Indicator <Indicator>
  * Get-TCThreats -IndicatorType Host -Indicator <Indicator>
  * Get-TCThreats -IndicatorType URL -Indicator <Indicator>
* Get-TCSecurityLabels
  * Get-TCSecurityLabels
  * Get-TCSecurityLabels -AdversaryID <AdversaryID>
  * Get-TCSecurityLabels -EmailID <EmailID>
  * Get-TCSecurityLabels -IncidentID <IncidentID>
  * Get-TCSecurityLabels -SecurityLabel <SecurityLabel>
  * Get-TCSecurityLabels -SignatureID <SignatureID>
  * Get-TCSecurityLabels -ThreatID <ThreatID>
  * Get-TCSecurityLabels -IndicatorType Address -Indicator <Indicator>
  * Get-TCSecurityLabels -IndicatorType EmailAddress -Indicator <Indicator>
  * Get-TCSecurityLabels -IndicatorType File -Indicator <Indicator>
  * Get-TCSecurityLabels -IndicatorType Host -Indicator <Indicator>
  * Get-TCSecurityLabels -IndicatorType URL -Indicator <Indicator>
* Get-TCTags
  * Get-TCTags
  * Get-TCTags -AdversaryID <AdversaryID>
  * Get-TCTags -EmailID <EmailID>
  * Get-TCTags -IncidentID <IncidentID>
  * Get-TCTags -SignatureID <SignatureID>
  * Get-TCTags -TagName <TagName>
  * Get-TCTags -ThreatID <ThreatID>
  * Get-TCTags -IndicatorType Address -Indicator <Indicator>
  * Get-TCTags -IndicatorType EmailAddress -Indicator <Indicator>
  * Get-TCTags -IndicatorType File -Indicator <Indicator>
  * Get-TCTags -IndicatorType Host -Indicator <Indicator>
  * Get-TCTags -IndicatorType URL -Indicator <Indicator>
* Get-TCVictims
  * Get-TCVictims
  * Get-TCVictims -AdversaryID <AdversaryID>
  * Get-TCVictims -EmailID <EmailID>
  * Get-TCVictims -IncidentID <IncidentID>
  * Get-TCVictims -SignatureID <SignatureID>
  * Get-TCVictims -ThreatID <ThreatID>
  * Get-TCVictims -IndicatorType Address -Indicator <Indicator>
  * Get-TCVictims -IndicatorType EmailAddress -Indicator <Indicator>
  * Get-TCVictims -IndicatorType File -Indicator <Indicator>
  * Get-TCVictims -IndicatorType Host -Indicator <Indicator>
  * Get-TCVictims -IndicatorType URL -Indicator <Indicator>
* Get-TCVictimAssets
  * Get-TCVictimAssets
  * Get-TCVictimAssets -AdversaryID <AdversaryID>
  * Get-TCVictimAssets -AdversaryID <AdversaryID> -AssetType <AssetType>
  * Get-TCVictimAssets -EmailID <EmailID>
  * Get-TCVictimAssets -EmailID <EmailID> -AssetType <AssetType>
  * Get-TCVictimAssets -IncidentID <IncidentID>
  * Get-TCVictimAssets -IncidentID <IncidentID> -AssetType <AssetType>
  * Get-TCVictimAssets -SignatureID <SignatureID>
  * Get-TCVictimAssets -SignatureID <SignatureID> -AssetType <AssetType>
  * Get-TCVictimAssets -ThreatID <ThreatID>
  * Get-TCVictimAssets -ThreatID <ThreatID> -AssetType <AssetType>
  * Get-TCVictimAssets -VictimID <VictimID>
  * Get-TCVictimAssets -VictimID <VictimID> -AssetType <AssetType>
  * Get-TCVictimAssets -IndicatorType Address -Indicator <Indicator>
  * Get-TCVictimAssets -IndicatorType EmailAddress -Indicator <Indicator>
  * Get-TCVictimAssets -IndicatorType File -Indicator <Indicator>
  * Get-TCVictimAssets -IndicatorType Host -Indicator <Indicator>
  * Get-TCVictimAssets -IndicatorType URL -Indicator <Indicator>