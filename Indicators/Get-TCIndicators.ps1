function Get-TCIndicators {
<#
.SYNOPSIS
	Gets a list of indicators from Threat Connect.  Default is all indicators for the API Key's organization

.PARAMETER AdversaryID
	Optional parameter used to list all indicators linked to a specific Adversary ID.
	
.PARAMETER EmailID
	Optional parameter used to list all indicators linked to a specific Email ID.
	
.PARAMETER IncidentID
	Optional parameter used to list all indicators linked to a specific Incident ID.
	
.PARAMETER SecurityLabel
	Optional parameter used to list all indicators with a specific Security Label.
	
.PARAMETER SignatureID
	Optional parameter used to list all indicators linked to a specific Signature ID.

.PARAMETER TagName
	Optional parameter used to list all indicators with a specific Tag.

.PARAMETER ThreatID
	Optional parameter used to list all indicators linked to a specific Threat ID.

.PARAMETER VictimID
	Optional parameter used to list all indicators linked to a specific Victim ID.
	
.PARAMETER IndicatorType
	Optional paramter used to list all indicators of a certain type.  IndicatorType could be Host, EmailAddress, File, Address, or URL.
	This parameter can be used alongside many of the other switches.

.PARAMETER Indicator
	Optional paramter used to work with a specific indicator.  Must be used along with the IndicatorType parameter.

.PARAMETER DNSResolutions
	Optional parameter to list the DNS Resolutions for a specific Host indicator.

.PARAMETER FileOccurences
	Optional parameter to list the File Occurences for a specific File indicator.

.PARAMETER Owner
	Optional Parameter to define a specific Community (or other "Owner") from which to retrieve indicators.
	This switch can be used alongside some of the other switches.

.PARAMETER ResultStart
	Optional Parameter. Use when dealing with large number of results.
	If you use ResultLimit of 100, you can use a ResultStart value of 100 to show items 100 through 200.

.PARAMETER ResultLimit
	Optional Parameter. Change the maximum number of results to display. Default is 100, Maximum is 500.

.EXAMPLE
	Get-TCIndicators
	
.EXAMPLE
	Get-TCIndicators -AdversaryID <AdversaryID>

.EXAMPLE
	Get-TCIndicators -AdversaryID <AdversaryID> -IndicatorType <IndicatorType>
	
.EXAMPLE
	Get-TCIndicators -EmailID <EmailID>
	
.EXAMPLE
	Get-TCIndicators -EmailID <EmailID> -IndicatorType <IndicatorType>
	
.EXAMPLE
	Get-TCIndicators -IncidentID <IncidentID>	
	
.EXAMPLE
	Get-TCIndicators -IncidentID <IncidentID> -IndicatorType <IndicatorType>

.EXAMPLE
	Get-TCIndicators -IndicatorType <IndicatorType>

.EXAMPLE
	Get-TCIndicators -IndicatorType <IndicatorType> -Indicator <Indicator>

.EXAMPLE
	Get-TCIndicators -IndicatorType Host -Indicator <Indicator> -DNSResolutions

.EXAMPLE
	Get-TCIndicators -IndicatorType File -Indicator <Indicator> -FileOccurrences

.EXAMPLE
	Get-TCIndicators -SecurityLabel <SecurityLabel>
	
.EXAMPLE
	Get-TCIndicators -SecurityLabel <SecurityLabel> -IndicatorType <IndicatorType>
	
.EXAMPLE
	Get-TCIndicators -SignatureID <SignatureID>
		
.EXAMPLE
	Get-TCIndicators -SignatureID <SignatureID> -IndicatorType <IndicatorType>
	
.EXAMPLE
	Get-TCIndicators -TagName <TagName>
		
.EXAMPLE
	Get-TCIndicators -TagName <TagName> -IndicatorType <IndicatorType>
	
.EXAMPLE
	Get-TCIndicators -ThreatID <ThreatID>
		
.EXAMPLE
	Get-TCIndicators -ThreatID <ThreatID> -IndicatorType <IndicatorType>
	
.EXAMPLE
	Get-TCIndicators -VictimID <VictimID>
		
.EXAMPLE
	Get-TCIndicators -VictimID <VictimID> -IndicatorType <IndicatorType>
#>
[CmdletBinding(DefaultParameterSetName='Default')]Param(
	[Parameter(Mandatory=$True,ParameterSetName='AdversaryID')]
		[ValidateNotNullOrEmpty()][String]$AdversaryID,
	[Parameter(Mandatory=$True,ParameterSetName='EmailID')]
		[ValidateNotNullOrEmpty()][String]$EmailID,
	[Parameter(Mandatory=$True,ParameterSetName='IncidentID')]
		[ValidateNotNullOrEmpty()][String]$IncidentID,
	[Parameter(Mandatory=$False,ParameterSetName='AdversaryID')]
	[Parameter(Mandatory=$False,ParameterSetName='EmailID')]
	[Parameter(Mandatory=$False,ParameterSetName='IncidentID')]
	[Parameter(Mandatory=$True,ParameterSetName='Indicator')]
	[Parameter(Mandatory=$False,ParameterSetName='SecurityLabel')]
	[Parameter(Mandatory=$False,ParameterSetName='SignatureID')]
	[Parameter(Mandatory=$False,ParameterSetName='TagName')]
	[Parameter(Mandatory=$False,ParameterSetName='ThreatID')]
	[Parameter(Mandatory=$False,ParameterSetName='VictimID')]
		[ValidateSet('Address','EmailAddress','File','Host','URL')][String]$IndicatorType,
	[Parameter(Mandatory=$False,ParameterSetName='Indicator')]
		[ValidateNotNullOrEmpty()][String]$Indicator,
	[Parameter(Mandatory=$True,ParameterSetName='SecurityLabel')]
		[ValidateNotNullOrEmpty()][String]$SecurityLabel,
	[Parameter(Mandatory=$True,ParameterSetName='SignatureID')]
		[ValidateNotNullOrEmpty()][String]$SignatureID,
	[Parameter(Mandatory=$True,ParameterSetName='TagName')]
		[ValidateNotNullOrEmpty()][String]$TagName,
	[Parameter(Mandatory=$True,ParameterSetName='ThreatID')]
		[ValidateNotNullOrEmpty()][String]$ThreatID,
	[Parameter(Mandatory=$True,ParameterSetName='VictimID')]
		[ValidateNotNullOrEmpty()][String]$VictimID,
	[Parameter(Mandatory=$False,ParameterSetName='Default')]
	[Parameter(Mandatory=$False,ParameterSetName='Indicator')]
	[Parameter(Mandatory=$False,ParameterSetName='SecurityLabel')]
	[Parameter(Mandatory=$False,ParameterSetName='TagName')]
		[ValidateNotNullOrEmpty()][String]$Owner,
	[Parameter(Mandatory=$False,ParameterSetName='Default')]
	[Parameter(Mandatory=$False,ParameterSetName='Indicator')]
	[Parameter(Mandatory=$False,ParameterSetName='AdversaryID')]
	[Parameter(Mandatory=$False,ParameterSetName='EmailID')]
	[Parameter(Mandatory=$False,ParameterSetName='IncidentID')]
	[Parameter(Mandatory=$False,ParameterSetName='SecurityLabel')]
	[Parameter(Mandatory=$False,ParameterSetName='SignatureID')]
	[Parameter(Mandatory=$False,ParameterSetName='TagName')]
	[Parameter(Mandatory=$False,ParameterSetName='ThreatID')]
	[Parameter(Mandatory=$False,ParameterSetName='VictimID')]
		[ValidateRange('1','500')][int]$ResultLimit=100,
	[Parameter(Mandatory=$False,ParameterSetName='Default')]
	[Parameter(Mandatory=$False,ParameterSetName='Indicator')]
	[Parameter(Mandatory=$False,ParameterSetName='AdversaryID')]
	[Parameter(Mandatory=$False,ParameterSetName='EmailID')]
	[Parameter(Mandatory=$False,ParameterSetName='IncidentID')]
	[Parameter(Mandatory=$False,ParameterSetName='SecurityLabel')]
	[Parameter(Mandatory=$False,ParameterSetName='SignatureID')]
	[Parameter(Mandatory=$False,ParameterSetName='TagName')]
	[Parameter(Mandatory=$False,ParameterSetName='ThreatID')]
	[Parameter(Mandatory=$False,ParameterSetName='VictimID')]
		[ValidateNotNullOrEmpty()][int]$ResultStart
)
# Add the Dynamic Parameters DNSResolutions and FileOccurrences
DynamicParam {
	# Initialize Parameter Dictionary
	$ParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
	
	# If Host IndicatorType is selected, add DNSResolutions Parameter Availability
	if ($IndicatorType -eq "Host") {
		# Create attribute and attribute collection
		$DNSResolutionsAttribute = New-Object System.Management.Automation.ParameterAttribute
		$DNSResolutionsAttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
		# Set the Parameter Properties
		$DNSResolutionsAttribute.Mandatory = $False
		$DNSResolutionsAttribute.ParameterSetName="Indicator"
		# Add to the Attribute Collection
		$DNSResolutionsAttributeCollection.Add($DNSResolutionsAttribute)
		# Create Parameter with Attribute Collection
		$DNSResolutionsParameter = New-Object System.Management.Automation.RuntimeDefinedParameter("DNSResolutions", [Switch], $DNSResolutionsAttributeCollection)
		# Add the Parameter to the Parameter Dictionary
		$ParameterDictionary.Add("DNSResolutions", $DNSResolutionsParameter)
	}
	
	# If File IndicatorType is selected, add FileOccurrences Parameter Availability
	if ($IndicatorType -eq "File") {
		# Create attribute and attribute collection
		$FileOccurrencesAttribute = New-Object System.Management.Automation.ParameterAttribute
		$FileOccurrencesAttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
		# Set the Parameter Properties
		$FileOccurrencesAttribute.Mandatory = $False
		$FileOccurrencesAttribute.ParameterSetName = "Indicator"
		# Add to the Attribute Collection
		$FileOccurrencesAttributeCollection.Add($FileOccurrencesAttribute)
		# Create Parameter with Attribute Collection
		$FileOccurrencesParameter = New-Object System.Management.Automation.RuntimeDefinedParameter("FileOccurrences", [Switch], $FileOccurrencesAttributeCollection)
		$FileOccurrencesParameter.Value = $True
		# Add the Parameter to the Parameter Dictionary
		$ParameterDictionary.Add("FileOccurrences", $FileOccurrencesParameter)
	}
	return $ParameterDictionary
}

Process {
	# Construct the Child URL based on the Parameter Set that was chosen
	switch ($PSCmdlet.ParameterSetName) {
		"AdversaryID" {
			$APIChildURL = "/v2/groups/adversaries/" + $AdversaryID + "/indicators"
		}
		
		"EmailID" {
			$APIChildURL = "/v2/groups/emails/" + $EmailID + "/indicators"
		}
		
		"IncidentID" {
			$APIChildURL = "/v2/groups/incidents/" + $IncidentID + "/indicators"
		}
		
		"Indicator" {
			# Craft Indicator Child URL based on Indicator Type
			switch ($IndicatorType) {
				"Address" {
					$APIChildURL = "/v2/indicators/addresses"
				}
				"EmailAddress" {
					$APIChildURL = "/v2/indicators/emailAddresses"
				}
				"File" {
					$APIChildURL = "/v2/indicators/files"
					
				}
				"Host" {
					$APIChildURL = "/v2/indicators/hosts"
				}
				"URL" {
					$APIChildURL = "/v2/indicators/urls"
				}
			}
			
			if ($Indicator) {
				if ($IndicatorType -eq "URL") {
					# URLs need to be converted to a friendly format first
					$EscapedIndicator = Get-EscapedURIString -String $Indicator
					$APIChildURL = $APIChildURL + "/" + $EscapedIndicator
				} else {
					$APIChildURL = $APIChildURL + "/" + $Indicator
				}
				
				# Add to Child URL if File Occurrences were requested
				if ($PSBoundParameters.FileOccurrences) {
					$APIChildURL = $APIChildURL + "/fileOccurrences"
				}
				# Add to the Child URL if DNS Resolutions were requested
				if ($PSBoundParameters.DNSResolutions) {
					$APIChildURL = $APIChildURL + "/dnsResolutions"
				}
			}
		}
		
		"SecurityLabel" {
			# Need to escape the URI in case there are any spaces or special characters
			$SecurityLabel = Get-EscapedURIString -String $SecurityLabel
			$APIChildURL = "/v2/securityLabels/" + $SecurityLabel + "/indicators"
		}
		
		"SignatureID" {
			$APIChildURL = "/v2/groups/signatures/" + $SignatureID + "/indicators"
		}
		
		"TagName" {
			# Need to escape the URI in case there are any spaces or special characters
			$TagName = Get-EscapedURIString -String $TagName
			$APIChildURL = "/v2/tags/" + $TagName + "/indicators"
		}
		
		"ThreatID" {
			$APIChildURL = "/v2/groups/threats/" + $ThreatID + "/indicators"
		}
		
		"VictimID" {
			$APIChildURL = "/v2/victims/" + $VictimID + "/indicators"
		}
		
		Default {
			# Use this if nothing else is specified
			$APIChildURL ="/v2/indicators"
		}
	}
	
	if ($IndicatorType -and $PSCmdlet.ParameterSetName -ne "Indicator" ) {
		switch ($IndicatorType) {
			"Address" {
				$APIChildURL = $APIChildURL + "/addresses"
			}
			
			"Host" {
				$APIChildURL = $APIChildURL + "/hosts"
			}
			
			"EmailAddress" {
				$APIChildURL = $APIChildURL + "/emailAddresses"
			}
			
			"File" {
				$APIChildURL = $APIChildURL + "/files"
			}
			
			"URL" {
				$APIChildURL = $APIChildURL + "/urls"
			}
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
	
	if ($IndicatorType -eq "URL" -and $Indicator) { if ($IndicatorType -eq "URL" -and $Indicator) { [URLFix]::ForceCanonicalPathAndQuery($URI) } }
	
	# Query the API
	$Response = Invoke-RestMethod -Method "GET" -Uri $URI -Headers $AuthorizationHeaders -ErrorAction SilentlyContinue
	
	# Verify API Request Status as Success or Print the Error
	if ($Response.Status -eq "Success") {
		$Response.data | Get-Member -MemberType NoteProperty | Where-Object { $_.Name -ne "resultCount" } | Select-Object -ExpandProperty Name | ForEach-Object { $Response.data.$_ }
	} else {
		Write-Verbose "API Request failed with the following error:`n $($Response.Status)"
	}
}
}
