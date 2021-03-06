function Get-TCVictims {
<#
.SYNOPSIS
	Gets a list of victims from Threat Connect.  Default is all victims for the API Key's organization

.PARAMETER AdversaryID
	Optional parameter used to list all victims linked to a specific Adversary ID.
	
.PARAMETER EmailID
	Optional parameter used to list all victims linked to a specific Email ID.
	
.PARAMETER IncidentID
	Optional parameter used to list all victims linked to a specific Incident ID.
	
.PARAMETER SignatureID
	Optional parameter used to list all victims linked to a specific Signature ID.

.PARAMETER ThreatID
	Optional parameter used to list all victims linked to a specific Threat ID.

.PARAMETER VictimID
	Optional parameter used to list a specific victim.

.PARAMETER IndicatorType
	Optional paramter used to list all victims linked to a specific Indicator.  IndicatorType could be Host, EmailAddress, File, Address, or URL.
	Must be used along with the Indicator parameter.
	
.PARAMETER Indicator
	Optional paramter used to list all victims linked to a specific Indicator.
	Must be used along with the IndicatorType parameter.

.PARAMETER Owner
	Optional Parameter to define a specific Community (or other "Owner") from which to retrieve victims.
	This switch can be used alongside some of the other switches.

.PARAMETER ResultStart
	Optional Parameter. Use when dealing with large number of results.
	If you use ResultLimit of 100, you can use a ResultStart value of 100 to show items 100 through 200.

.PARAMETER ResultLimit
	Optional Parameter. Change the maximum number of results to display. Default is 100, Maximum is 500.

.EXAMPLE
	Get-TCVictims
	
.EXAMPLE
	Get-TCVictims -AdversaryID <AdversaryID>
	
.EXAMPLE
	Get-TCVictims -EmailID <EmailID>
	
.EXAMPLE
	Get-TCVictims -IncidentID <IncidentID>
	
.EXAMPLE
	Get-TCVictims -SignatureID <SignatureID>
	
.EXAMPLE
	Get-TCVictims -ThreatID <ThreatID>
	
.EXAMPLE
	Get-TCVictims -IndicatorType Address -Indicator <Indicator>

.EXAMPLE
	Get-TCVictims -IndicatorType EmailAddress -Indicator <Indicator>

.EXAMPLE
	Get-TCVictims -IndicatorType File -Indicator <Indicator>

.EXAMPLE
	Get-TCVictims -IndicatorType Host -Indicator <Indicator>

.EXAMPLE
	Get-TCVictims -IndicatorType URL -Indicator <Indicator>
	
#>
[CmdletBinding(DefaultParameterSetName='Default')]Param(
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
	[Parameter(Mandatory=$False,ParameterSetName='Default')]
	[Parameter(Mandatory=$False,ParameterSetName='Indicator')]
		[ValidateNotNullOrEmpty()][String]$Owner,
	[Parameter(Mandatory=$False,ParameterSetName='Default')]
	[Parameter(Mandatory=$False,ParameterSetName='Indicator')]
	[Parameter(Mandatory=$False,ParameterSetName='AdversaryID')]
	[Parameter(Mandatory=$False,ParameterSetName='EmailID')]
	[Parameter(Mandatory=$False,ParameterSetName='IncidentID')]
	[Parameter(Mandatory=$False,ParameterSetName='SignatureID')]
	[Parameter(Mandatory=$False,ParameterSetName='ThreatID')]
		[ValidateRange('1','500')][int]$ResultLimit=100,
	[Parameter(Mandatory=$False,ParameterSetName='Default')]
	[Parameter(Mandatory=$False,ParameterSetName='Indicator')]
	[Parameter(Mandatory=$False,ParameterSetName='AdversaryID')]
	[Parameter(Mandatory=$False,ParameterSetName='EmailID')]
	[Parameter(Mandatory=$False,ParameterSetName='IncidentID')]
	[Parameter(Mandatory=$False,ParameterSetName='SignatureID')]
	[Parameter(Mandatory=$False,ParameterSetName='ThreatID')]
		[ValidateNotNullOrEmpty()][int]$ResultStart
)

# Construct the Child URL based on the Parameter Set that was chosen
switch ($PSCmdlet.ParameterSetName) {
	"AdversaryID" {
		$APIChildURL = "/v2/groups/adversaries/" + $AdversaryID + "/victims"
	}
	
	"EmailID" {
		$APIChildURL = "/v2/groups/emails/" + $EmailID + "/victims"
	}
	
	"IncidentID" {
		$APIChildURL = "/v2/groups/incidents/" + $IncidentID + "/victims"
	}
	
	"Indicator" {
		# Craft Indicator Child URL based on Indicator Type
		switch ($IndicatorType) {
			"Address" {
				$APIChildURL = "/v2/indicators/addresses/" + $Indicator + "/victims"
			}
			"EmailAddress" {
				$APIChildURL = "/v2/indicators/emailAddresses/" + $Indicator + "/victims"
			}
			"File" {
				$APIChildURL = "/v2/indicators/files/" + $Indicator + "/victims"
			}
			"Host" {
				$APIChildURL = "/v2/indicators/hosts/" + $Indicator + "/victims"
			}
			"URL" {
				# URLs need to be converted to a friendly format first
				$Indicator = Get-EscapedURIString -String $Indicator
				$APIChildURL = "/v2/indicators/urls/" + $Indicator + "/victims"
			}
		}
	}
	
	"SignatureID" {
		$APIChildURL = "/v2/groups/signatures/" + $SignatureID + "/victims"
	}
	
	"ThreatID" {
		$APIChildURL = "/v2/groups/threats/" + $ThreatID + "/victims"
	}
	
	"VictimID" {
		$APIChildURL = "/v2/victims/" + $VictimID
	}
	
	Default {
		# Use this if nothing else is specified
		$APIChildURL ="/v2/victims"
	}
}

# Add to the URI if Owner, ResultStart, or ResultLimit was specified
if ($Owner -and $ResultStart -and $ResultLimit -ne 100) {
	$APIChildURL = $APIChildURL + "?owner=" + (Get-EscapedURIString -String $Owner) + "&resultStart=" + $ResultStart + "&resultLimit=" + $ResultLimit
} elseif ($Owner -and $ResultStart -and $ResultLimit -eq 100) {
	$APIChildURL = $APIChildURL + "?owner=" + (Get-EscapedURIString -String $Owner) + "&resultStart=" + $ResultStart
} elseif ($Owner -and (-not $ResultStart) -and $ResultLimit -ne 100) {
	$APIChildURL = $APIChildURL + "?owner=" + (Get-EscapedURIString -String $Owner) + "&resultLimit=" + $ResultLimit
} elseif ($Owner -and (-not $ResultStart) -and $ResultLimit -eq 100) {
	$APIChildURL = $APIChildURL + "?owner=" + (Get-EscapedURIString -String $Owner)
} elseif ((-not $Owner) -and $ResultStart -and $ResultLimit -ne 100) {
	$APIChildURL = $APIChildURL + "?resultStart=" + $ResultStart + "&resultLimit=" + $ResultLimit
} elseif ((-not $Owner) -and $ResultStart -and $ResultLimit -eq 100) {
	$APIChildURL = $APIChildURL + "?resultStart=" + $ResultStart
} elseif ((-not $Owner) -and (-not $ResultStart) -and $ResultLimit -ne 100) {
	$APIChildURL = $APIChildURL + "?resultLimit=" + $ResultLimit
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
