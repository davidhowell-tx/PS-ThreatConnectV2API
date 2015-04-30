<#
Author: David Howell  @DavidHowellTX
Last Modified: 04/30/2015
Version: 0 [incomplete]

Thanks to Threat Connect for their awesome documentation on how to use the API.
#>

# Set the API Access ID, Secret Key, and Base URL for the API
# Place the values within the single quotes. If your Secret Key has a single quote in it, you may need to escape it by using the backtick before the single quote
[String]$Script:AccessID = ''
[String]$Script:SecretKey = ''
[String]$Script:APIBaseURL = 'https://api.threatconnect.com'

function Get-ThreatConnectHeaders {
	<#
	.SYNOPSIS
		Generates the HTTP headers for an API request.
		
	.DESCRIPTION
		Each API request must contain headers that include a HMAC-SHA256, Base64 encoded signature and the Unix Timestamp. This function handles creation of those headers.
		This command is intended to be used by other commands in the Threat Connect Module.  It is not intended to be used manually at the command line, unless for testing purposes.
	
	.PARAMETER RequestMethod
		The HTTP Request Method for the API request (GET, PUT, POST, DELETE)
	
	.PARAMETER URL
		The Child URL for the API Request (Exclude the root, eg. https://api.threatconnect.com should not be included)
		
	.EXAMPLE
		Get-ThreatConnectHeaders -RequestMethod "GET" -URL "/v2/owners"
	#>
	[CmdletBinding()]Param(
		[Parameter(Mandatory=$True)][String]$RequestMethod,
		[Parameter(Mandatory=$True)][String]$URL
	)
	# Calculate Unix UTC time
	[String]$Timestamp = [Math]::Floor([Decimal](Get-Date -Date (Get-Date).ToUniversalTime() -UFormat "%s"))
	# Create the HMAC-SHA256 Object to work with
	$HMACSHA256 = New-Object System.Security.Cryptography.HMACSHA256
	# Set the HMAC Key to the API Secret Key
	$HMACSHA256.Key = [System.Text.Encoding]::UTF8.GetBytes($Script:SecretKey)
	# Generate the HMAC Signature using API URI, Request Method, and Unix Time
	$HMACSignature = $HMACSHA256.ComputeHash([System.Text.Encoding]::UTF8.GetBytes("$URL`:$RequestMethod`:$Timestamp"))
	# Base 64 Encode the HMAC Signature
	$HMACBase64 = [System.Convert]::ToBase64String($HMACSignature)
	# Craft the full Authorization Header
	$Authorization = "TC $($Script:AccessID)`:$HMACBase64"
	# Create a HashTable where we will add the Authorization information
	$Headers = New-Object System.Collections.Hashtable
	$Headers.Add("Timestamp",$Timestamp)
	$Headers.Add("Authorization",$Authorization)
	return $Headers
}

function Get-EscapedURIString {
	<#
	.SYNOPSIS
		Escapes special characters in the provided URI string (spaces become %20, etc.)
	
	.DESCRIPTION
		Uses System.URI's method "EscapeDataString" to convert special characters into their hex representation.
	
	.PARAMETER String
		The string that requires conversion
	
	.EXAMPLE
		Get-EscapedURIString -String "Test Escaping"
	#>
	
	[CmdletBinding()]Param(
		[Parameter(Mandatory=$True)][String]$String
	)
	
	# Use System.URI's "EscapeDataString" method to convert
	[System.Uri]::EscapeDataString($String)
}

function Get-Owners {
	<#
	.SYNOPSIS
		Gets a list of Owners visible to your API key.
	
	.DESCRIPTION
		Owners include your API Key's Organization, and any other communities to which it subscribes.
	#>
	
	# Child URL for the API query
	$APIChildURL = "/v2/owners"
	
	# Generate the appropriate Headers for the API Request
	$AuthorizationHeaders = Get-ThreatConnectHeaders -RequestMethod "GET" -URL $APIChildURL
	
	# Query the API
	$Response = Invoke-RestMethod -Method "GET" -Uri ($Script:APIBaseURL + $APIChildURL) -Headers $AuthorizationHeaders -ErrorAction SilentlyContinue
	
	# Check for Status=Success and print the results or the Error
	if ($Response.Status -eq "Success") {
		$Response.data.owner
	} else {
		Write-Error "API Request failed with the following error:`n $($Response.Status)"
	}
}

function Get-Adversaries {
	<#
	.SYNOPSIS
		Gets a list of Adversaries from Threat Connect.  Default is all Adversaries for the API Key's organization
		
	.PARAMETER Owner
		Optional Parameter to define a specific Community (or other "Owner") from which to retrieve adversaries.
		This switch can be used alongside the other switches.
	
	.PARAMETER AdversaryID
		Optional Parameter to specify an Adversary ID for which to query.
		
	.PARAMETER EmailID
		Optional parameter used to list all Adversaries linked to a specific Email ID.
		
	.PARAMETER IncidentID
		Optional parameter used to list all Adversaries linked to a specific Incident ID.
		
	.PARAMETER SecurityLabel
		Optional parameter used to list all Adversaries with a specific Security Label.
		
	.PARAMETER SignatureID
		Optional parameter used to list all Adversaries linked to a specific Signature ID.
	
	.PARAMETER TagName
		Optional parameter used to list all Adversaries with a specific Tag.
	
	.PARAMETER ThreatID
		Optional parameter used to list all Adversaries linked to a specific Threat ID.
	
	.PARAMETER VictimID
		Optional parameter used to list all Adversaries linked to a specific Victim ID.

	.EXAMPLE
		Get-Adversaries
		
	.EXAMPLE
		Get-Adversaries -AdversaryID 123456
		
	.EXAMPLE
		Get-Adversaries -EmailID "123456"
		
	.EXAMPLE
		Get-Adversaries -IncidentID "123456"
	
	.EXAMPLE
		Get-Adversaries -SecurityLabel "Confidential"
		
	.EXAMPLE
		Get-Adversaries -SignatureID "123456"
		
	.EXAMPLE
		Get-Adversaries -TagName "BadStuff"
		
	.EXAMPLE
		Get-Adversaries -ThreatID "123456"
		
	.EXAMPLE
		Get-Adversaries -VictimID "123456"
	#>
	[CmdletBinding(DefaultParameterSetName='Default')]Param(
		[Parameter(Mandatory=$False,ParameterSetName='Default')]
		[Parameter(Mandatory=$False,ParameterSetName='AdversaryID')]
		[Parameter(Mandatory=$False,ParameterSetName='EmailID')]
		[Parameter(Mandatory=$False,ParameterSetName='IncidentID')]
		[Parameter(Mandatory=$False,ParameterSetName='SecurityLabel')]
		[Parameter(Mandatory=$False,ParameterSetName='SignatureID')]
		[Parameter(Mandatory=$False,ParameterSetName='TagName')]
		[Parameter(Mandatory=$False,ParameterSetName='ThreatID')]
		[Parameter(Mandatory=$False,ParameterSetName='VictimID')]
			[ValidateNotNullOrEmpty()][String]$Owner,
		[Parameter(Mandatory=$True,ParameterSetName='AdversaryID')]
			[ValidateNotNullOrEmpty()][String]$AdversaryID,
		[Parameter(Mandatory=$True,ParameterSetName='EmailID')]
			[ValidateNotNullOrEmpty()][String]$EmailID,
		[Parameter(Mandatory=$True,ParameterSetName='IncidentID')]
			[ValidateNotNullOrEmpty()][String]$IncidentID,
		[Parameter(Mandatory=$True,ParameterSetName='SecurityLabel')]
			[ValidateNotNullOrEmpty()][String]$SecurityLabel,
		[Parameter(Mandatory=$True,ParameterSetName='SignatureID')]
			[ValidateNotNullOrEmpty()][String]$SignatureID,
		[Parameter(Mandatory=$True,ParameterSetName='TagName')]
			[ValidateNotNullOrEmpty()][String]$TagName,
		[Parameter(Mandatory=$True,ParameterSetName='ThreatID')]
			[ValidateNotNullOrEmpty()][String]$ThreatID,
		[Parameter(Mandatory=$True,ParameterSetName='VictimID')]
			[ValidateNotNullOrEmpty()][String]$VictimID
	)
	
	# Construct the Child URL based on the Parameter Set that was chosen
	switch ($PSCmdlet.ParameterSetName) {
		"AdversaryID" {
			$APIChildURL = "/v2/groups/adversaries/" + $AdversaryID
		}
		
		"EmailID" {
			$APIChildURL = "/v2/groups/emails/" + $EmailID + "/groups/adversaries"
		}
		
		"IncidentID" {
			$APIChildURL = "/v2/groups/incidents/" + $IncidentID + "/groups/adversaries"
		}

		"SecurityLabel" {
			# Need to escape the URI in case there are any spaces or special characters
			$SecurityLabel = Get-EscapedURIString -String $SecurityLabel
			$APIChildURL = "/v2/securityLabels/" + $SecurityLabel + "/groups/adversaries"
		}
		
		"SignatureID" {
			$APIChildURL = "/v2/groups/signatures/" + $SignatureID + "/groups/adversaries"
		}
		
		"TagName" {
			# Need to escape the URI in case there are any spaces or special characters
			$TagName = Get-EscapedURIString -String $TagName
			$APIChildURL = "/v2/tags/" + $TagName + "/groups/adversaries"		
		}
		
		"ThreatID" {
			$APIChildURL = "/v2/groups/threats/" + $ThreatID + "/groups/adversaries"
		}
		
		"VictimID" {
			$APIChildURL = "/v2/victims/" + $VictimID + "/groups/adversaries"
		}
		
		Default {
			# Use this if nothing else is specified
			$APIChildURL ="/v2/groups/adversaries"
		}
	}

	# Add to the Child URL if an Owner was supplied
	if ($Owner) {
		# Escape the provided Owner using Get-EscapedURIString, and add the value to the end of the Child URL
		$APIChildURL = $APIChildURL + "?owner=" + (Get-EscapedURIString -String $Owner)
	}
	
	# Generate the appropriate Headers for the API Request
	$AuthorizationHeaders = Get-ThreatConnectHeaders -RequestMethod "GET" -URL $APIChildURL
	
	# Query the API
	$Response = Invoke-RestMethod -Method "GET" -Uri ($Script:APIBaseURL + $APIChildURL) -Headers $AuthorizationHeaders -ErrorAction SilentlyContinue
	
	# Check for Status=Success and print the results or the Error
	if ($Response.Status -eq "Success") {
		$Response.data.adversary
	} else {
		Write-Error "API Request failed with the following error:`n $($Response.Status)"
	}
}

function Get-Emails {
	<#
	.SYNOPSIS
		Gets a list of emails from Threat Connect.  Default is all emails for the API Key's organization
		
	.PARAMETER Owner
		Optional Parameter to define a specific Community (or other "Owner") from which to retrieve emails.
		This switch can be used alongside the other switches.
	
	.PARAMETER AdversaryID
		Optional parameter used to list all emails linked to a specific Adversary ID.
		
	.PARAMETER EmailID
		Optional parameter used to specify an Email ID for which to query.
		
	.PARAMETER IncidentID
		Optional parameter used to list all emails linked to a specific Incident ID.
		
	.PARAMETER SecurityLabel
		Optional parameter used to list all emails with a specific Security Label.
		
	.PARAMETER SignatureID
		Optional parameter used to list all emails linked to a specific Signature ID.
	
	.PARAMETER TagName
		Optional parameter used to list all emails with a specific Tag.
	
	.PARAMETER ThreatID
		Optional parameter used to list all emails linked to a specific Threat ID.
	
	.PARAMETER VictimID
		Optional parameter used to list all emails linked to a specific Victim ID.

	.EXAMPLE
		Get-Emails
		
	.EXAMPLE
		Get-Emails -AdversaryID 123456
		
	.EXAMPLE
		Get-Emails -EmailID "123456"
		
	.EXAMPLE
		Get-Emails -IncidentID "123456"
	
	.EXAMPLE
		Get-Emails -SecurityLabel "Confidential"
		
	.EXAMPLE
		Get-Emails -SignatureID "123456"
		
	.EXAMPLE
		Get-Emails -TagName "BadStuff"
		
	.EXAMPLE
		Get-Emails -ThreatID "123456"
		
	.EXAMPLE
		Get-Emails -VictimID "123456"
	#>
	[CmdletBinding(DefaultParameterSetName='Default')]Param(
		[Parameter(Mandatory=$False,ParameterSetName='Default')]
		[Parameter(Mandatory=$False,ParameterSetName='AdversaryID')]
		[Parameter(Mandatory=$False,ParameterSetName='EmailID')]
		[Parameter(Mandatory=$False,ParameterSetName='IncidentID')]
		[Parameter(Mandatory=$False,ParameterSetName='SecurityLabel')]
		[Parameter(Mandatory=$False,ParameterSetName='SignatureID')]
		[Parameter(Mandatory=$False,ParameterSetName='TagName')]
		[Parameter(Mandatory=$False,ParameterSetName='ThreatID')]
		[Parameter(Mandatory=$False,ParameterSetName='VictimID')]
			[ValidateNotNullOrEmpty()][String]$Owner,
		[Parameter(Mandatory=$True,ParameterSetName='AdversaryID')]
			[ValidateNotNullOrEmpty()][String]$AdversaryID,
		[Parameter(Mandatory=$True,ParameterSetName='EmailID')]
			[ValidateNotNullOrEmpty()][String]$EmailID,
		[Parameter(Mandatory=$True,ParameterSetName='IncidentID')]
			[ValidateNotNullOrEmpty()][String]$IncidentID,
		[Parameter(Mandatory=$True,ParameterSetName='SecurityLabel')]
			[ValidateNotNullOrEmpty()][String]$SecurityLabel,
		[Parameter(Mandatory=$True,ParameterSetName='SignatureID')]
			[ValidateNotNullOrEmpty()][String]$SignatureID,
		[Parameter(Mandatory=$True,ParameterSetName='TagName')]
			[ValidateNotNullOrEmpty()][String]$TagName,
		[Parameter(Mandatory=$True,ParameterSetName='ThreatID')]
			[ValidateNotNullOrEmpty()][String]$ThreatID,
		[Parameter(Mandatory=$True,ParameterSetName='VictimID')]
			[ValidateNotNullOrEmpty()][String]$VictimID
	)
	
	# Construct the Child URL based on the Parameter Set that was chosen
	switch ($PSCmdlet.ParameterSetName) {
		"AdversaryID" {
			$APIChildURL = "/v2/groups/adversaries/" + $AdversaryID + "/groups/emails"
		}
		
		"EmailID" {
			$APIChildURL = "/v2/groups/emails/" + $EmailID
		}
		
		"IncidentID" {
			$APIChildURL = "/v2/groups/incidents/" + $IncidentID + "/groups/emails"
		}
		
		"SecurityLabel" {
			# Need to escape the URI in case there are any spaces or special characters
			$SecurityLabel = Get-EscapedURIString -String $SecurityLabel
			$APIChildURL = "/v2/securityLabels/" + $SecurityLabel + "/groups/emails"
		}
		
		"SignatureID" {
			$APIChildURL = "/v2/groups/signatures/" + $SignatureID + "/groups/emails"
		}
		
		"TagName" {
			# Need to escape the URI in case there are any spaces or special characters
			$TagName = Get-EscapedURIString -String $TagName
			$APIChildURL = "/v2/tags/" + $TagName + "/groups/emails"		
		}		
		
		"ThreatID" {
			$APIChildURL = "/v2/groups/threats/" + $ThreatID + "/groups/emails"
		}

		"VictimID" {
			$APIChildURL = "/v2/victims/" + $VictimID + "/groups/emails"
		}
		
		Default {
			# Use this if nothing else is specified
			$APIChildURL ="/v2/groups/emails"
		}
	}

	# Add to the Child URL if an Owner was supplied
	if ($Owner) {
		# Escape the provided Owner using Get-EscapedURIString, and add the value to the end of the Child URL
		$APIChildURL = $APIChildURL + "?owner=" + (Get-EscapedURIString -String $Owner)
	}
	
	# Generate the appropriate Headers for the API Request
	$AuthorizationHeaders = Get-ThreatConnectHeaders -RequestMethod "GET" -URL $APIChildURL
	
	# Query the API
	$Response = Invoke-RestMethod -Method "GET" -Uri ($Script:APIBaseURL + $APIChildURL) -Headers $AuthorizationHeaders -ErrorAction SilentlyContinue
	
	# Check for Status=Success and print the results or the Error
	if ($Response.Status -eq "Success") {
		$Response.data.email
	} else {
		Write-Error "API Request failed with the following error:`n $($Response.Status)"
	}
}

function Get-Incidents {
	<#
	.SYNOPSIS
		Gets a list of incidents from Threat Connect.  Default is all incidents for the API Key's organization
		
	.PARAMETER Owner
		Optional Parameter to define a specific Community (or other "Owner") from which to retrieve incidents.
		This switch can be used alongside the other switches.
	
	.PARAMETER AdversaryID
		Optional parameter used to list all incidents linked to a specific Adversary ID.
		
	.PARAMETER EmailID
		Optional parameter used to list all incidents linked to a specific Email ID.
		
	.PARAMETER IncidentID
		Optional parameter used to specify an Incident ID for which to query.
		
	.PARAMETER SecurityLabel
		Optional parameter used to list all incidents with a specific Security Label.
		
	.PARAMETER SignatureID
		Optional parameter used to list all incidents linked to a specific Signature ID.
	
	.PARAMETER TagName
		Optional parameter used to list all incidents with a specific Tag.
	
	.PARAMETER ThreatID
		Optional parameter used to list all incidents linked to a specific Threat ID.
	
	.PARAMETER VictimID
		Optional parameter used to list all incidents linked to a specific Victim ID.

	.EXAMPLE
		Get-Incidents
		
	.EXAMPLE
		Get-Incidents -AdversaryID 123456
		
	.EXAMPLE
		Get-Incidents -EmailID "123456"
		
	.EXAMPLE
		Get-Incidents -IncidentID "123456"
	
	.EXAMPLE
		Get-Incidents -SecurityLabel "Confidential"
		
	.EXAMPLE
		Get-Incidents -SignatureID "123456"
		
	.EXAMPLE
		Get-Incidents -TagName "BadStuff"
		
	.EXAMPLE
		Get-Incidents -ThreatID "123456"
		
	.EXAMPLE
		Get-Incidents -VictimID "123456"
	#>
	[CmdletBinding(DefaultParameterSetName='Default')]Param(
		[Parameter(Mandatory=$False,ParameterSetName='Default')]
		[Parameter(Mandatory=$False,ParameterSetName='AdversaryID')]
		[Parameter(Mandatory=$False,ParameterSetName='EmailID')]
		[Parameter(Mandatory=$False,ParameterSetName='IncidentID')]
		[Parameter(Mandatory=$False,ParameterSetName='SecurityLabel')]
		[Parameter(Mandatory=$False,ParameterSetName='SignatureID')]
		[Parameter(Mandatory=$False,ParameterSetName='TagName')]
		[Parameter(Mandatory=$False,ParameterSetName='ThreatID')]
		[Parameter(Mandatory=$False,ParameterSetName='VictimID')]
			[ValidateNotNullOrEmpty()][String]$Owner,
		[Parameter(Mandatory=$True,ParameterSetName='AdversaryID')]
			[ValidateNotNullOrEmpty()][String]$AdversaryID,
		[Parameter(Mandatory=$True,ParameterSetName='EmailID')]
			[ValidateNotNullOrEmpty()][String]$EmailID,
		[Parameter(Mandatory=$True,ParameterSetName='IncidentID')]
			[ValidateNotNullOrEmpty()][String]$IncidentID,
		[Parameter(Mandatory=$True,ParameterSetName='SecurityLabel')]
			[ValidateNotNullOrEmpty()][String]$SecurityLabel,
		[Parameter(Mandatory=$True,ParameterSetName='SignatureID')]
			[ValidateNotNullOrEmpty()][String]$SignatureID,
		[Parameter(Mandatory=$True,ParameterSetName='TagName')]
			[ValidateNotNullOrEmpty()][String]$TagName,
		[Parameter(Mandatory=$True,ParameterSetName='ThreatID')]
			[ValidateNotNullOrEmpty()][String]$ThreatID,
		[Parameter(Mandatory=$True,ParameterSetName='VictimID')]
			[ValidateNotNullOrEmpty()][String]$VictimID
	)
	
	# Construct the Child URL based on the Parameter Set that was chosen
	switch ($PSCmdlet.ParameterSetName) {
		"AdversaryID" {
			$APIChildURL = "/v2/groups/adversaries/" + $AdversaryID + "/groups/incidents"
		}
		
		"EmailID" {
			$APIChildURL = "/v2/groups/emails/" + $EmailID + "/groups/incidents"
		}
		
		"IncidentID" {
			$APIChildURL = "/v2/groups/incidents/" + $IncidentID
		}
		
		"SecurityLabel" {
			# Need to escape the URI in case there are any spaces or special characters
			$SecurityLabel = Get-EscapedURIString -String $SecurityLabel
			$APIChildURL = "/v2/securityLabels/" + $SecurityLabel + "/groups/incidents"
		}
		
		"SignatureID" {
			$APIChildURL = "/v2/groups/signatures/" + $SignatureID + "/groups/incidents"
		}
		
		"TagName" {
			# Need to escape the URI in case there are any spaces or special characters
			$TagName = Get-EscapedURIString -String $TagName
			$APIChildURL = "/v2/tags/" + $TagName + "/groups/incidents"		
		}
		
		"ThreatID" {
			$APIChildURL = "/v2/groups/threats/" + $ThreatID  + "/groups/incidents"
		}
		
		"VictimID" {
			$APIChildURL = "/v2/victims/" + $VictimID + "/groups/incidents"
		}
		
		Default {
			# Use this if nothing else is specified
			$APIChildURL ="/v2/groups/incidents"
		}
	}

	# Add to the Child URL if an Owner was supplied
	if ($Owner) {
		# Escape the provided Owner using Get-EscapedURIString, and add the value to the end of the Child URL
		$APIChildURL = $APIChildURL + "?owner=" + (Get-EscapedURIString -String $Owner)
	}
	
	# Generate the appropriate Headers for the API Request
	$AuthorizationHeaders = Get-ThreatConnectHeaders -RequestMethod "GET" -URL $APIChildURL
	
	# Query the API
	$Response = Invoke-RestMethod -Method "GET" -Uri ($Script:APIBaseURL + $APIChildURL) -Headers $AuthorizationHeaders -ErrorAction SilentlyContinue
	
	# Check for Status=Success and print the results or the Error
	if ($Response.Status -eq "Success") {
		$Response.data.incident
	} else {
		Write-Error "API Request failed with the following error:`n $($Response.Status)"
	}
}

function Get-Signatures {
	<#
	.SYNOPSIS
		Gets a list of signatures from Threat Connect.  Default is all signatures for the API Key's organization
		
	.PARAMETER Owner
		Optional Parameter to define a specific Community (or other "Owner") from which to retrieve signatures.
		This switch can be used alongside the other switches.
	
	.PARAMETER AdversaryID
		Optional parameter used to list all signatures linked to a specific Adversary ID.
		
	.PARAMETER EmailID
		Optional parameter used to list all signatures linked to a specific Email ID.
		
	.PARAMETER IncidentID
		Optional parameter used to list all signatures linked to a specific Incident ID.
		
	.PARAMETER SecurityLabel
		Optional parameter used to list all signatures with a specific Security Label.
		
	.PARAMETER SignatureID
		Optional parameter used to specify a Signature ID for which to query.
	
	.PARAMETER TagName
		Optional parameter used to list all signatures with a specific Tag.
	
	.PARAMETER ThreatID
		Optional parameter used to list all signatures linked to a specific Threat ID.
	
	.PARAMETER VictimID
		Optional parameter used to list all signatures linked to a specific Victim ID.

	.EXAMPLE
		Get-Signatures
		
	.EXAMPLE
		Get-Signatures -AdversaryID 123456
		
	.EXAMPLE
		Get-Signatures -EmailID "123456"
		
	.EXAMPLE
		Get-Signatures -IncidentID "123456"
	
	.EXAMPLE
		Get-Signatures -SecurityLabel "Confidential"
		
	.EXAMPLE
		Get-Signatures -SignatureID "123456"
		
	.EXAMPLE
		Get-Signatures -TagName "BadStuff"
		
	.EXAMPLE
		Get-Signatures -ThreatID "123456"
		
	.EXAMPLE
		Get-Signatures -VictimID "123456"
	#>
	[CmdletBinding(DefaultParameterSetName='Default')]Param(
		[Parameter(Mandatory=$False,ParameterSetName='Default')]
		[Parameter(Mandatory=$False,ParameterSetName='AdversaryID')]
		[Parameter(Mandatory=$False,ParameterSetName='EmailID')]
		[Parameter(Mandatory=$False,ParameterSetName='IncidentID')]
		[Parameter(Mandatory=$False,ParameterSetName='SecurityLabel')]
		[Parameter(Mandatory=$False,ParameterSetName='SignatureID')]
		[Parameter(Mandatory=$False,ParameterSetName='TagName')]
		[Parameter(Mandatory=$False,ParameterSetName='ThreatID')]
		[Parameter(Mandatory=$False,ParameterSetName='VictimID')]
			[ValidateNotNullOrEmpty()][String]$Owner,
		[Parameter(Mandatory=$True,ParameterSetName='AdversaryID')]
			[ValidateNotNullOrEmpty()][String]$AdversaryID,
		[Parameter(Mandatory=$True,ParameterSetName='EmailID')]
			[ValidateNotNullOrEmpty()][String]$EmailID,
		[Parameter(Mandatory=$True,ParameterSetName='IncidentID')]
			[ValidateNotNullOrEmpty()][String]$IncidentID,
		[Parameter(Mandatory=$True,ParameterSetName='SecurityLabel')]
			[ValidateNotNullOrEmpty()][String]$SecurityLabel,
		[Parameter(Mandatory=$True,ParameterSetName='SignatureID')]
			[ValidateNotNullOrEmpty()][String]$SignatureID,
		[Parameter(Mandatory=$True,ParameterSetName='TagName')]
			[ValidateNotNullOrEmpty()][String]$TagName,
		[Parameter(Mandatory=$True,ParameterSetName='ThreatID')]
			[ValidateNotNullOrEmpty()][String]$ThreatID,
		[Parameter(Mandatory=$True,ParameterSetName='VictimID')]
			[ValidateNotNullOrEmpty()][String]$VictimID
	)
	
	# Construct the Child URL based on the Parameter Set that was chosen
	switch ($PSCmdlet.ParameterSetName) {
		"AdversaryID" {
			$APIChildURL = "/v2/groups/adversaries/" + $AdversaryID + "/groups/signatures"
		}
		
		"EmailID" {
			$APIChildURL = "/v2/groups/emails/" + $EmailID + "/groups/signatures"
		}
		
		"IncidentID" {
			$APIChildURL = "/v2/groups/incidents/" + $IncidentID + "/groups/signatures"
		}
		
		"SecurityLabel" {
			# Need to escape the URI in case there are any spaces or special characters
			$SecurityLabel = Get-EscapedURIString -String $SecurityLabel
			$APIChildURL = "/v2/securityLabels/" + $SecurityLabel + "/groups/signatures"
		}
		
		"SignatureID" {
			$APIChildURL = "/v2/groups/signatures/" + $SignatureID
		}
		
		"TagName" {
			# Need to escape the URI in case there are any spaces or special characters
			$TagName = Get-EscapedURIString -String $TagName
			$APIChildURL = "/v2/tags/" + $TagName + "/groups/signatures"		
		}		
		
		"ThreatID" {
			$APIChildURL = "/v2/groups/threats/" + $ThreatID + "/groups/signatures"
		}
		
		"VictimID" {
			$APIChildURL = "/v2/victims/" + $VictimID + "/groups/signatures"
		}
		
		Default {
			# Use this if nothing else is specified
			$APIChildURL ="/v2/groups/signatures"
		}
	}

	# Add to the Child URL if an Owner was supplied
	if ($Owner) {
		# Escape the provided Owner using Get-EscapedURIString, and add the value to the end of the Child URL
		$APIChildURL = $APIChildURL + "?owner=" + (Get-EscapedURIString -String $Owner)
	}
	
	# Generate the appropriate Headers for the API Request
	$AuthorizationHeaders = Get-ThreatConnectHeaders -RequestMethod "GET" -URL $APIChildURL
	
	# Query the API
	$Response = Invoke-RestMethod -Method "GET" -Uri ($Script:APIBaseURL + $APIChildURL) -Headers $AuthorizationHeaders -ErrorAction SilentlyContinue
	
	# Check for Status=Success and print the results or the Error
	if ($Response.Status -eq "Success") {
		$Response.data.signature
	} else {
		Write-Error "API Request failed with the following error:`n $($Response.Status)"
	}
}

function Get-Threats {
	<#
	.SYNOPSIS
		Gets a list of threats from Threat Connect.  Default is all threats for the API Key's organization
		
	.PARAMETER Owner
		Optional Parameter to define a specific Community (or other "Owner") from which to retrieve threats.
		This switch can be used alongside the other switches.
	
	.PARAMETER AdversaryID
		Optional parameter used to list all threats linked to a specific Adversary ID.
		
	.PARAMETER EmailID
		Optional parameter used to list all threats linked to a specific Email ID.
		
	.PARAMETER IncidentID
		Optional parameter used to list all threats linked to a specific Incident ID.
		
	.PARAMETER SecurityLabel
		Optional parameter used to list all threats with a specific Security Label.
		
	.PARAMETER SignatureID
		Optional parameter used to list all threats linked to a specific Signature ID.
	
	.PARAMETER TagName
		Optional parameter used to list all threats with a specific Tag.
	
	.PARAMETER ThreatID
		Optional parameter used to specify a Threat ID for which to query.
	
	.PARAMETER VictimID
		Optional parameter used to list all threats linked to a specific Victim ID.

	.EXAMPLE
		Get-Threats
		
	.EXAMPLE
		Get-Threats -AdversaryID 123456
		
	.EXAMPLE
		Get-Threats -EmailID "123456"
		
	.EXAMPLE
		Get-Threats -IncidentID "123456"
	
	.EXAMPLE
		Get-Threats -SecurityLabel "Confidential"
		
	.EXAMPLE
		Get-Threats -SignatureID "123456"
		
	.EXAMPLE
		Get-Threats -TagName "BadStuff"
		
	.EXAMPLE
		Get-Threats -ThreatID "123456"
		
	.EXAMPLE
		Get-Threats -VictimID "123456"
	#>
	[CmdletBinding(DefaultParameterSetName='Default')]Param(
		[Parameter(Mandatory=$False,ParameterSetName='Default')]
		[Parameter(Mandatory=$False,ParameterSetName='AdversaryID')]
		[Parameter(Mandatory=$False,ParameterSetName='EmailID')]
		[Parameter(Mandatory=$False,ParameterSetName='IncidentID')]
		[Parameter(Mandatory=$False,ParameterSetName='SecurityLabel')]
		[Parameter(Mandatory=$False,ParameterSetName='SignatureID')]
		[Parameter(Mandatory=$False,ParameterSetName='TagName')]
		[Parameter(Mandatory=$False,ParameterSetName='ThreatID')]
		[Parameter(Mandatory=$False,ParameterSetName='VictimID')]
			[ValidateNotNullOrEmpty()][String]$Owner,
		[Parameter(Mandatory=$True,ParameterSetName='AdversaryID')]
			[ValidateNotNullOrEmpty()][String]$AdversaryID,
		[Parameter(Mandatory=$True,ParameterSetName='EmailID')]
			[ValidateNotNullOrEmpty()][String]$EmailID,
		[Parameter(Mandatory=$True,ParameterSetName='IncidentID')]
			[ValidateNotNullOrEmpty()][String]$IncidentID,
		[Parameter(Mandatory=$True,ParameterSetName='SecurityLabel')]
			[ValidateNotNullOrEmpty()][String]$SecurityLabel,
		[Parameter(Mandatory=$True,ParameterSetName='SignatureID')]
			[ValidateNotNullOrEmpty()][String]$SignatureID,
		[Parameter(Mandatory=$True,ParameterSetName='TagName')]
			[ValidateNotNullOrEmpty()][String]$TagName,
		[Parameter(Mandatory=$True,ParameterSetName='ThreatID')]
			[ValidateNotNullOrEmpty()][String]$ThreatID,
		[Parameter(Mandatory=$True,ParameterSetName='VictimID')]
			[ValidateNotNullOrEmpty()][String]$VictimID
	)
	
	# Construct the Child URL based on the Parameter Set that was chosen
	switch ($PSCmdlet.ParameterSetName) {
		"AdversaryID" {
			$APIChildURL = "/v2/groups/adversaries/" + $AdversaryID + "/groups/threats"
		}
		
		"EmailID" {
			$APIChildURL = "/v2/groups/emails/" + $EmailID + "/groups/threats"
		}
		
		"IncidentID" {
			$APIChildURL = "/v2/groups/incidents/" + $IncidentID + "/groups/threats"
		}
		
		"SecurityLabel" {
			# Need to escape the URI in case there are any spaces or special characters
			$SecurityLabel = Get-EscapedURIString -String $SecurityLabel
			$APIChildURL = "/v2/securityLabels/" + $SecurityLabel + "/groups/threats"
		}
		
		"SignatureID" {
			$APIChildURL = "/v2/groups/signatures/" + $SignatureID + "/groups/threats"
		}
		
		"TagName" {
			# Need to escape the URI in case there are any spaces or special characters
			$TagName = Get-EscapedURIString -String $TagName
			$APIChildURL = "/v2/tags/" + $TagName + "/groups/threats"		
		}
		
		"ThreatID" {
			$APIChildURL = "/v2/groups/threats/" + $ThreatID
		}
		
		"VictimID" {
			$APIChildURL = "/v2/victims/" + $VictimID + "/groups/threats"
		}
		
		Default {
			# Use this if nothing else is specified
			$APIChildURL ="/v2/groups/threats"
		}
	}

	# Add to the Child URL if an Owner was supplied
	if ($Owner) {
		# Escape the provided Owner using Get-EscapedURIString, and add the value to the end of the Child URL
		$APIChildURL = $APIChildURL + "?owner=" + (Get-EscapedURIString -String $Owner)
	}
	
	# Generate the appropriate Headers for the API Request
	$AuthorizationHeaders = Get-ThreatConnectHeaders -RequestMethod "GET" -URL $APIChildURL
	
	# Query the API
	$Response = Invoke-RestMethod -Method "GET" -Uri ($Script:APIBaseURL + $APIChildURL) -Headers $AuthorizationHeaders -ErrorAction SilentlyContinue
	
	# Check for Status=Success and print the results or the Error
	if ($Response.Status -eq "Success") {
		$Response.data.threat
	} else {
		Write-Error "API Request failed with the following error:`n $($Response.Status)"
	}
}

function Get-Attributes {
	<#
	.SYNOPSIS
		Gets a list of attributes for the specified "group".  (Group being Adversaries, Emails, Incidents, Signatures and Threats)
	
	.PARAMETER AdversaryID
		Optional parameter used to list all attributes linked to a specific Adversary ID.
	
	.PARAMETER EmailID
		Optional parameter used to list all attributes linked to a specific Email ID.
	
	.PARAMETER IncidentID
		Optional parameter used to list all attributes linked to a specific Incident ID.
	
	.PARAMETER SignatureID
		Optional parameter used to list all attributes linked to a specific Signature ID.
	
	.PARAMETER ThreatID
		Optional parameter used to list all attributes linked to a specific Threat ID.
	
	.EXAMPLE
		Get-Attributes -AdversaryID "123456"
	
	.EXAMPLE
		Get-Attributes -EmailID "123456"
	
	.EXAMPLE
		Get-Attributes -IncidentID "123456"
	
	.EXAMPLE
		Get-Attributes -SignatureID "123456"
	
	.EXAMPLE
		Get-Attributes -ThreatID "123456"
	#>
	[CmdletBinding()]Param(
		[Parameter(Mandatory=$True,ParameterSetName='AdversaryID')]
			[ValidateNotNullOrEmpty()][String]$AdversaryID,
		[Parameter(Mandatory=$True,ParameterSetName='EmailID')]
			[ValidateNotNullOrEmpty()][String]$EmailID,
		[Parameter(Mandatory=$True,ParameterSetName='IncidentID')]
			[ValidateNotNullOrEmpty()][String]$IncidentID,
		[Parameter(Mandatory=$True,ParameterSetName='SignatureID')]
			[ValidateNotNullOrEmpty()][String]$SignatureID,
		[Parameter(Mandatory=$True,ParameterSetName='ThreatID')]
			[ValidateNotNullOrEmpty()][String]$ThreatID
	)
	
	# Construct the Child URL based on the Parameter Set that was chosen
	switch ($PSCmdlet.ParameterSetName) {
		"AdversaryID" { 
			$APIChildURL = "/v2/groups/adversaries/" + $AdversaryID + "/attributes"
		}
		
		"EmailID" { 
			$APIChildURL = "/v2/groups/emails/" + $AdversaryID + "/attributes"
		}
		
		"IncidentID" { 
			$APIChildURL = "/v2/groups/incidents/" + $AdversaryID + "/attributes"
		}
		
		"SignatureID" { 
			$APIChildURL = "/v2/groups/signatures/" + $AdversaryID + "/attributes"
		}
		
		"ThreatID" { 
			$APIChildURL = "/v2/groups/threats/" + $AdversaryID + "/attributes"
		}
	}

	# Generate the appropriate Headers for the API Request
	$AuthorizationHeaders = Get-ThreatConnectHeaders -RequestMethod "GET" -URL $APIChildURL
	
	# Query the API
	$Response = Invoke-RestMethod -Method "GET" -Uri ($Script:APIBaseURL + $APIChildURL) -Headers $AuthorizationHeaders -ErrorAction SilentlyContinue
	
	# Check for Status=Success and print the results or the Error
	if ($Response.Status -eq "Success") {
		$Response.data.attribute
	} else {
		Write-Error "API Request failed with the following error:`n $($Response.Status)"
	}
}

function Get-SecurityLabels {
	<#
	.SYNOPSIS
		Gets a list of security labels from Threat Connect.  Default is all security labels for the API Key's organization
		
	.PARAMETER Owner
		Optional Parameter to define a specific Community (or other "Owner") from which to retrieve security labels.
		This switch can be used alongside the other switches.
	
	.PARAMETER AdversaryID
		Optional parameter used to list all security labels linked to a specific Adversary ID.
		
	.PARAMETER EmailID
		Optional parameter used to list all security labels linked to a specific Email ID.
		
	.PARAMETER IncidentID
		Optional parameter used to list all security labels linked to a specific Incident ID.
		
	.PARAMETER SignatureID
		Optional parameter used to list all security labels linked to a specific Signature ID.
	
	.PARAMETER ThreatID
		Optional parameter used to list all security labels linked to a specific Threat ID.

	.EXAMPLE
		Get-SecurityLabels
		
	.EXAMPLE
		Get-SecurityLabels -AdversaryID 123456
		
	.EXAMPLE
		Get-SecurityLabels -EmailID "123456"
		
	.EXAMPLE
		Get-SecurityLabels -IncidentID "123456"
	
	.EXAMPLE
		Get-SecurityLabels -SecurityLabel "Confidential"
		
	.EXAMPLE
		Get-SecurityLabels -SignatureID "123456"
		
	.EXAMPLE
		Get-SecurityLabels -ThreatID "123456"
		
	#>
	[CmdletBinding(DefaultParameterSetName='Default')]Param(
		[Parameter(Mandatory=$False,ParameterSetName='Default')]
		[Parameter(Mandatory=$False,ParameterSetName='SecurityLabel')]
			[ValidateNotNullOrEmpty()][String]$Owner,
		[Parameter(Mandatory=$True,ParameterSetName='AdversaryID')]
			[ValidateNotNullOrEmpty()][String]$AdversaryID,
		[Parameter(Mandatory=$True,ParameterSetName='EmailID')]
			[ValidateNotNullOrEmpty()][String]$EmailID,
		[Parameter(Mandatory=$True,ParameterSetName='IncidentID')]
			[ValidateNotNullOrEmpty()][String]$IncidentID,
		[Parameter(Mandatory=$True,ParameterSetName='SecurityLabel')]
			[ValidateNotNullOrEmpty()][String]$SecurityLabel,
		[Parameter(Mandatory=$True,ParameterSetName='SignatureID')]
			[ValidateNotNullOrEmpty()][String]$SignatureID,
		[Parameter(Mandatory=$True,ParameterSetName='ThreatID')]
			[ValidateNotNullOrEmpty()][String]$ThreatID
	)
	
	# Construct the Child URL based on the Parameter Set that was chosen
	switch ($PSCmdlet.ParameterSetName) {
		"AdversaryID" {
			$APIChildURL = "/v2/groups/adversaries/" + $AdversaryID + "/securityLabels"
		}
		
		"EmailID" {
			$APIChildURL = "/v2/groups/emails/" + $EmailID + "/securityLabels"
		}
		
		"IncidentID" {
			$APIChildURL = "/v2/groups/incidents/" + $IncidentID + "/securityLabels"
		}
		
		"SecurityLabel" {
			# Need to escape the URI in case there are any spaces or special characters
			$SecurityLabel = Get-EscapedURIString -String $SecurityLabel
			$APIChildURL = "/v2/securityLabels/" + $SecurityLabel
		}
		
		"SignatureID" {
			$APIChildURL = "/v2/groups/signatures/" + $SignatureID + "/securityLabels"
		}
		
		"ThreatID" {
			$APIChildURL = "/v2/groups/threats/" + $ThreatID + "/securityLabels"
		}
		
		Default {
			# Use this if nothing else is specified
			$APIChildURL ="/v2/securityLabels"
		}
	}

	# Add to the Child URL if an Owner was supplied
	if ($Owner) {
		# Escape the provided Owner using Get-EscapedURIString, and add the value to the end of the Child URL
		$APIChildURL = $APIChildURL + "?owner=" + (Get-EscapedURIString -String $Owner)
	}
	
	# Generate the appropriate Headers for the API Request
	$AuthorizationHeaders = Get-ThreatConnectHeaders -RequestMethod "GET" -URL $APIChildURL
	
	# Query the API
	$Response = Invoke-RestMethod -Method "GET" -Uri ($Script:APIBaseURL + $APIChildURL) -Headers $AuthorizationHeaders -ErrorAction SilentlyContinue
	
	# Check for Status=Success and print the results or the Error
	if ($Response.Status -eq "Success") {
		$Response.data.securityLabel
	} else {
		Write-Error "API Request failed with the following error:`n $($Response.Status)"
	}
}

function Get-Tags {
	<#
	.SYNOPSIS
		Gets a list of tags from Threat Connect.  Default is all tags for the API Key's organization
		
	.PARAMETER Owner
		Optional Parameter to define a specific Community (or other "Owner") from which to retrieve tags.
		This switch can be used alongside the other switches.
	
	.PARAMETER AdversaryID
		Optional parameter used to list all tags linked to a specific Adversary ID.
		
	.PARAMETER EmailID
		Optional parameter used to list all tags linked to a specific Email ID.
		
	.PARAMETER IncidentID
		Optional parameter used to list all tags linked to a specific Incident ID.
		
	.PARAMETER SignatureID
		Optional parameter used to list all tags linked to a specific Signature ID.
	
	.PARAMETER TagName
		Optional parameter used to specify a Tag Name for which to query.
	
	.PARAMETER ThreatID
		Optional parameter used to list all tags linked to a specific Threat ID.

	.EXAMPLE
		Get-Tags
		
	.EXAMPLE
		Get-Tags -AdversaryID 123456
		
	.EXAMPLE
		Get-Tags -EmailID "123456"
		
	.EXAMPLE
		Get-Tags -IncidentID "123456"
		
	.EXAMPLE
		Get-Tags -SignatureID "123456"
		
	.EXAMPLE
		Get-Tags -TagName "BadStuff"
		
	.EXAMPLE
		Get-Tags -ThreatID "123456"
		
	#>
	[CmdletBinding(DefaultParameterSetName='Default')]Param(
		[Parameter(Mandatory=$False,ParameterSetName='Default')]
		[Parameter(Mandatory=$False,ParameterSetName='TagName')]
			[ValidateNotNullOrEmpty()][String]$Owner,
		[Parameter(Mandatory=$True,ParameterSetName='AdversaryID')]
			[ValidateNotNullOrEmpty()][String]$AdversaryID,
		[Parameter(Mandatory=$True,ParameterSetName='EmailID')]
			[ValidateNotNullOrEmpty()][String]$EmailID,
		[Parameter(Mandatory=$True,ParameterSetName='IncidentID')]
			[ValidateNotNullOrEmpty()][String]$IncidentID,
		[Parameter(Mandatory=$True,ParameterSetName='SignatureID')]
			[ValidateNotNullOrEmpty()][String]$SignatureID,
		[Parameter(Mandatory=$True,ParameterSetName='TagName')]
			[ValidateNotNullOrEmpty()][String]$TagName,
		[Parameter(Mandatory=$True,ParameterSetName='ThreatID')]
			[ValidateNotNullOrEmpty()][String]$ThreatID
	)
	
	# Construct the Child URL based on the Parameter Set that was chosen
	switch ($PSCmdlet.ParameterSetName) {
		"AdversaryID" {
			$APIChildURL = "/v2/groups/adversaries/" + $AdversaryID + "/tags"
		}
		
		"EmailID" {
			$APIChildURL = "/v2/groups/emails/" + $EmailID + "/tags"
		}
		
		"IncidentID" {
			$APIChildURL = "/v2/groups/incidents/" + $IncidentID + "/tags"
		}
		
		"SignatureID" {
			$APIChildURL = "/v2/groups/signatures/" + $SignatureID + "/tags"
		}
		
		"TagName" {
			# Need to escape the URI in case there are any spaces or special characters
			$TagName = Get-EscapedURIString -String $TagName
			$APIChildURL = "/v2/tags/" + $TagName
		}
		
		"ThreatID" {
			$APIChildURL = "/v2/groups/threats/" + $ThreatID + "/tags"
		}
		
		Default {
			# Use this if nothing else is specified
			$APIChildURL ="/v2/tags"
		}
	}

	# Add to the Child URL if an Owner was supplied
	if ($Owner) {
		# Escape the provided Owner using Get-EscapedURIString, and add the value to the end of the Child URL
		$APIChildURL = $APIChildURL + "?owner=" + (Get-EscapedURIString -String $Owner)
	}
	
	# Generate the appropriate Headers for the API Request
	$AuthorizationHeaders = Get-ThreatConnectHeaders -RequestMethod "GET" -URL $APIChildURL
	
	# Query the API
	$Response = Invoke-RestMethod -Method "GET" -Uri ($Script:APIBaseURL + $APIChildURL) -Headers $AuthorizationHeaders -ErrorAction SilentlyContinue
	
	# Check for Status=Success and print the results or the Error
	if ($Response.Status -eq "Success") {
		$Response.data.tag
	} else {
		Write-Error "API Request failed with the following error:`n $($Response.Status)"
	}
}




