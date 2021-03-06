function Get-TCVictimAssets {
<#
.SYNOPSIS
	Gets a list of victim assets from Threat Connect.

.PARAMETER AdversaryID
	Optional parameter used to list all victim assets linked to a specific Adversary ID.
	
.PARAMETER EmailID
	Optional parameter used to list all victim assets linked to a specific Email ID.
	
.PARAMETER IncidentID
	Optional parameter used to list all victim assets linked to a specific Incident ID.
	
.PARAMETER SignatureID
	Optional parameter used to list all victim assets linked to a specific Signature ID.

.PARAMETER ThreatID
	Optional parameter used to list all victim assets linked to a specific Threat ID.

.PARAMETER VictimID
	Optional parameter used to list all victim assets linked to a specific Victim ID.

.PARAMETER AssetType
	Optional parameter used to specify an asset type to return.
	Possible values are EmailAddress, NetworkAccount, PhoneNumber, SocialNetwork, WebSite.

.PARAMETER IndicatorType
	Optional paramter used to list all victim assets linked to a specific Indicator.  IndicatorType could be Host, EmailAddress, File, Address, or URL.
	Must be used along with the Indicator parameter.
	
.PARAMETER Indicator
	Optional paramter used to list all victim assets linked to a specific Indicator.
	Must be used along with the IndicatorType parameter.

.PARAMETER Owner
	Optional Parameter to define a specific Community (or other "Owner") from which to retrieve victim assets.
	This switch can be used alongside some of the other switches.

.EXAMPLE
	Get-TCVictimAssets
	
.EXAMPLE
	Get-TCVictimAssets -AdversaryID <AdversaryID>

.EXAMPLE
	Get-TCVictimAssets -AdversaryID <AdversaryID> -AssetType <AssetType>

.EXAMPLE
	Get-TCVictimAssets -EmailID <EmailID>

.EXAMPLE
	Get-TCVictimAssets -EmailID <EmailID> -AssetType <AssetType>
	
.EXAMPLE
	Get-TCVictimAssets -IncidentID <IncidentID>

.EXAMPLE
	Get-TCVictimAssets -IncidentID <IncidentID> -AssetType <AssetType>
	
.EXAMPLE
	Get-TCVictimAssets -SignatureID <SignatureID>

.EXAMPLE
	Get-TCVictimAssets -SignatureID <SignatureID> -AssetType <AssetType>
	
.EXAMPLE
	Get-TCVictimAssets -ThreatID <ThreatID>

.EXAMPLE
	Get-TCVictimAssets -ThreatID <ThreatID> -AssetType <AssetType>

.EXAMPLE
	Get-TCVictimAssets -VictimID <VictimID>

EXAMPLE
	Get-TCVictimAssets -VictimID <VictimID> -AssetType <AssetType>
	
.EXAMPLE
	Get-TCVictimAssets -IndicatorType Address -Indicator <Indicator>

.EXAMPLE
	Get-TCVictimAssets -IndicatorType EmailAddress -Indicator <Indicator>

.EXAMPLE
	Get-TCVictimAssets -IndicatorType File -Indicator <Indicator>

.EXAMPLE
	Get-TCVictimAssets -IndicatorType Host -Indicator <Indicator>

.EXAMPLE
	Get-TCVictimAssets -IndicatorType URL -Indicator <Indicator>
	
#>
[CmdletBinding()]Param(
	[Parameter(Mandatory=$True,ParameterSetName='AdversaryID')]
		[ValidateNotNullOrEmpty()][String]$AdversaryID,
	[Parameter(Mandatory=$True,ParameterSetName='EmailID')]
		[ValidateNotNullOrEmpty()][String]$EmailID,
	[Parameter(Mandatory=$True,ParameterSetName='IncidentID')]
		[ValidateNotNullOrEmpty()][String]$IncidentID,
	[Parameter(Mandatory=$True,ParameterSetName='Indicator')]
		[ValidateSet('Address','EmailAddress','File','Host','URL')][String]$IndicatorType,
	[Parameter(Mandatory=$True,ParameterSetName='Indicator')]
		[ValidateNotNullOrEmpty()][String]$Indicator,
	[Parameter(Mandatory=$True,ParameterSetName='SignatureID')]
		[ValidateNotNullOrEmpty()][String]$SignatureID,
	[Parameter(Mandatory=$True,ParameterSetName='ThreatID')]
		[ValidateNotNullOrEmpty()][String]$ThreatID,
	[Parameter(Mandatory=$True,ParameterSetName='VictimID')]
		[ValidateNotNullOrEmpty()][String]$VictimID,
	[Parameter(Mandatory=$False,ParameterSetName='AdversaryID')]
	[Parameter(Mandatory=$False,ParameterSetName='EmailID')]
	[Parameter(Mandatory=$False,ParameterSetName='IncidentID')]
	[Parameter(Mandatory=$False,ParameterSetName='SignatureID')]
	[Parameter(Mandatory=$False,ParameterSetName='ThreatID')]
	[Parameter(Mandatory=$False,ParameterSetName='Indicator')]
	[Parameter(Mandatory=$False,ParameterSetName='VictimID')]
		[ValidateSet('EmailAddress','PhoneNumber','NetworkAccount','SocialNetwork','WebSite')][String]$AssetType,
	[Parameter(Mandatory=$False,ParameterSetName='Indicator')]
		[ValidateNotNullOrEmpty()][String]$Owner
)

# Construct the Child URL based on the Parameter Set that was chosen
switch ($PSCmdlet.ParameterSetName) {
	"AdversaryID" {
		$APIChildURL = "/v2/groups/adversaries/" + $AdversaryID + "/victimAssets"
	}
	
	"EmailID" {
		$APIChildURL = "/v2/groups/emails/" + $EmailID + "/victimAssets"
	}
	
	"IncidentID" {
		$APIChildURL = "/v2/groups/incidents/" + $IncidentID + "/victimAssets"
	}
	
	"Indicator" {
		# Craft Indicator Child URL based on Indicator Type
		switch ($IndicatorType) {
			"Address" {
				$APIChildURL = "/v2/indicators/addresses/" + $Indicator + "/victimAssets"
			}
			"EmailAddress" {
				$APIChildURL = "/v2/indicators/emailAddresses/" + $Indicator + "/victimAssets"
			}
			"File" {
				$APIChildURL = "/v2/indicators/files/" + $Indicator + "/victimAssets"
			}
			"Host" {
				$APIChildURL = "/v2/indicators/hosts/" + $Indicator + "/victimAssets"
			}
			"URL" {
				# URLs need to be converted to a friendly format first
				$Indicator = Get-EscapedURIString -String $Indicator
				$APIChildURL = "/v2/indicators/urls/" + $Indicator + "/victimAssets"
			}
		}
	}
	
	"SignatureID" {
		$APIChildURL = "/v2/groups/signatures/" + $SignatureID + "/victimAssets"
	}
	
	"ThreatID" {
		$APIChildURL = "/v2/groups/threats/" + $ThreatID + "/victimAssets"
	}
	
	"VictimID" {
		$APIChildURL = "/v2/victims/" + $VictimID + "/victimAssets"
	}
}

# Add to the Child URL if an Asset Type was supplied
if ($AssetType) {
	switch ($AssetType) {
		"EmailAddress" {
			$APIChildURL = $APIChildURL + "/emailAddresses"
		}
		
		"NetworkAccount" {
			$APIChildURL = $APIChildURL + "/networkAccounts"
		}
		
		"PhoneNumber" {
			$APIChildURL = $APIChildURL + "/phoneNumbers"
		}
		
		"SocialNetwork" {
			$APIChildURL = $APIChildURL + "/socialNetworks"
		}
		
		"WebSite" {
			$APIChildURL = $APIChildURL + "/webSites"
		}
	}	
}

# Add to the URI if Owner, ResultStart, or ResultLimit was specified
if ($Owner) {
	$APIChildURL = $APIChildURL + "?owner=" + (Get-EscapedURIString -String $Owner)
}

# Generate the appropriate Headers for the API Request
$AuthorizationHeaders = Get-ThreatConnectHeaders -RequestMethod "GET" -URL $APIChildURL

# Create the URI using System.URI (This fixes the issues with URL encoding)
$URI = New-Object System.Uri ($Script:APIBaseURL + $APIChildURL)

if ($IndicatorType -eq "URL" -and $Indicator) { [URLFix]::ForceCanonicalPathAndQuery($URI) }

# Query the API
$Response = Invoke-RestMethod -Method "GET" -Uri $URI -Headers $AuthorizationHeaders -ErrorAction SilentlyContinue

# Verify API Request Status as Success or Print the Error
if ($Response.Status -eq "Success") {
	$Response.data | Get-Member -MemberType NoteProperty | Where-Object { $_.Name -ne "resultCount" } | Select-Object -ExpandProperty Name | ForEach-Object { $Response.data.$_ }
} else {
	Write-Verbose "API Request failed with the following error:`n $($Response.Status)"
}
}
