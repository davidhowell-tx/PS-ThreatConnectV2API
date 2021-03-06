function Set-TCAttribute {
<#
.SYNOPSIS
	Modify an Attribute for a group or indicator in Threat Connect. Groups include Adversaries, Emails, Incidents, Threats, Signatures.

.PARAMETER AdversaryID
	Adversary ID of the Adversary for which you want to modify an attribute

.PARAMETER EmailID
	Email ID of the Email for which you want to modify an attribute

.PARAMETER IncidentID
	Incident ID of the Incident for which you want to modify an attribute
	
.PARAMETER ThreatID
	Threat ID of the Threat for which you want to modify an attribute
	
.PARAMETER SignatureID
	Signature ID of the Signature for which you want to modify an attribute

.PARAMETER Name
	If you only know the name of the Attribute, you can use this parameter. It will perform Get-TCAttributes to determine the Attribute ID for you.
	Must be used with a group ID.

.PARAMETER Value
	The new value for the attribute
	
.EXAMPLE
	Set-AdversaryAttribute -AdversaryID <AdversaryID> -Name <AttributeName> -Value <NewValue>

.EXAMPLE
	Set-AdversaryAttribute -EmailID <EmailID> -Name <AttributeName> -Value <NewValue>

.EXAMPLE
	Set-AdversaryAttribute -IncidentID <IncidentID> -Name <AttributeName> -Value <NewValue>

.EXAMPLE
	Set-AdversaryAttribute -ThreatID <ThreatID> -Name <AttributeName> -Value <NewValue>

.EXAMPLE
	Set-AdversaryAttribute -SignatureID <SignatureID> -Name <AttributeName> -Value <NewValue>
#>
[CmdletBinding()]Param(
	[Parameter(Mandatory=$True,ParameterSetName='AdversaryIDName')]
	[Parameter(Mandatory=$True,ParameterSetName='AdversaryIDAttributeID')]
		[ValidateNotNullOrEmpty()][String]$AdversaryID,
	[Parameter(Mandatory=$True,ParameterSetName='EmailIDName')]
	[Parameter(Mandatory=$True,ParameterSetName='EmailIDAttributeID')]
		[ValidateNotNullOrEmpty()][String]$EmailID,
	[Parameter(Mandatory=$True,ParameterSetName='IncidentIDName')]
	[Parameter(Mandatory=$True,ParameterSetName='IncidentIDAttributeID')]
		[ValidateNotNullOrEmpty()][String]$IncidentID,
	[Parameter(Mandatory=$True,ParameterSetName='ThreatIDName')]
	[Parameter(Mandatory=$True,ParameterSetName='ThreatIDAttributeID')]
		[ValidateNotNullOrEmpty()][String]$ThreatID,
	[Parameter(Mandatory=$True,ParameterSetName='SignatureIDName')]
	[Parameter(Mandatory=$True,ParameterSetName='SignatureIDAttributeID')]
		[ValidateNotNullOrEmpty()][String]$SignatureID,
	[Parameter(Mandatory=$True,ParameterSetName='AdversaryIDAttributeID')]
	[Parameter(Mandatory=$True,ParameterSetName='EmailIDAttributeID')]
	[Parameter(Mandatory=$True,ParameterSetName='IncidentIDAttributeID')]
	[Parameter(Mandatory=$True,ParameterSetName='ThreatIDAttributeID')]
	[Parameter(Mandatory=$True,ParameterSetName='SignatureIDAttributeID')]
		[ValidateNotNullOrEmpty()][String]$AttributeID,
	[Parameter(Mandatory=$True,ParameterSetName='AdversaryIDName')]
	[Parameter(Mandatory=$True,ParameterSetName='EmailIDName')]
	[Parameter(Mandatory=$True,ParameterSetName='IncidentIDName')]
	[Parameter(Mandatory=$True,ParameterSetName='ThreatIDName')]
	[Parameter(Mandatory=$True,ParameterSetName='SignatureIDName')]
		[ValidateNotNullOrEmpty()][String]$Name,
	[Parameter(Mandatory=$True)][ValidateNotNullOrEmpty()][String]$Value
)

# Switch to process based on selected parameters
switch($PSCmdlet.ParameterSetName) {
	"AdversaryIDName" {
		$AttributeInformation = Get-TCAttributes -AdversaryID $AdversaryID | Where-Object { $_.type -eq $Name }
		if ($AttributeInformation -ne $null -and $AttributeInformation -ne "") {
			$APIChildURL = "/v2/groups/adversaries/" + $AdversaryID + "/attributes/" + $AttributeInformation.id
		}
	}
	
	"EmailIDName" {
		$AttributeInformation = Get-TCAttributes -EmailID $EmailID | Where-Object { $_.type -eq $Name }
		if ($AttributeInformation -ne $null -and $AttributeInformation -ne "") {
			$APIChildURL = "/v2/groups/emails/" + $EmailID + "/attributes/" + $AttributeInformation.id
		}
	}
	
	"IncidentIDName" {
		$AttributeInformation = Get-TCAttributes -IncidentID $IncidentID | Where-Object { $_.type -eq $Name }
		if ($AttributeInformation -ne $null -and $AttributeInformation -ne "") {
			$APIChildURL = "/v2/groups/incidents/" + $IncidentID + "/attributes/" + $AttributeInformation.id
		}
	}
	
	"ThreatIDName" {
		$AttributeInformation = Get-TCAttributes -ThreatID $ThreatID | Where-Object { $_.type -eq $Name }
		if ($AttributeInformation -ne $null -and $AttributeInformation -ne "") {
			$APIChildURL = "/v2/groups/threats/" + $ThreatID + "/attributes/" + $AttributeInformation.id
		}
	}
	
	"SignatureIDName" {
		$AttributeInformation = Get-TCAttributes -SignatureID $SignatureID | Where-Object { $_.type -eq $Name }
		if ($AttributeInformation -ne $null -and $AttributeInformation -ne "") {
			$APIChildURL = "/v2/groups/signatures/" + $SignatureID + "/attributes/" + $AttributeInformation.id
		}
	}
	

	"AdversaryIDAttributeID" {
		$APIChildURL = "/v2/groups/adversaries/" + $AdversaryID + "/attributes/" + $AttributeID
	
	}
	
	"EmailIDAttributeID" {
		$APIChildURL = "/v2/groups/emails/" + $EmailID + "/attributes/" + $AttributeID
	}
	
	"IncidentIDAttributeID" {
		$APIChildURL = "/v2/groups/incidents/" + $IncidentID + "/attributes/" + $AttributeID
	}
	
	"ThreatIDAttributeID" {
		$APIChildURL = "/v2/groups/threats/" + $ThreatID + "/attributes/" + $AttributeID
	}
	
	"SignatureIDAttributeID" {
		$APIChildURL = "/v2/groups/signatures/" + $SignatureID + "/attributes/" + $AttributeID
	}
}

# Create a Custom Object and add the provided Value variable to the object
$CustomObject = "" | Select-Object -Property value
$CustomObject.value = $Value

# Convert the Custom Object to JSON format for use with the API
$JSONData = $CustomObject | ConvertTo-Json

# Generate the appropriate Headers for the API Request
$AuthorizationHeaders = Get-ThreatConnectHeaders -RequestMethod "PUT" -URL $APIChildURL

# Create the URI using System.URI (This fixes the issues with URL encoding)
$URI = New-Object System.Uri ($Script:APIBaseURL + $APIChildURL)

# Query the API
$Response = Invoke-RestMethod -Method "PUT" -Uri $URI -Headers $AuthorizationHeaders -Body $JSONData -ContentType "application/json" -ErrorAction SilentlyContinue

# Verify API Request Status as Success or Print the Error
if ($Response.Status -eq "Success") {
	$Response.data | Get-Member -MemberType NoteProperty | Where-Object { $_.Name -ne "resultCount" } | Select-Object -ExpandProperty Name | ForEach-Object { $Response.data.$_ }
} else {
	Write-Verbose "API Request failed with the following error:`n $($Response.Status)"
}
}
