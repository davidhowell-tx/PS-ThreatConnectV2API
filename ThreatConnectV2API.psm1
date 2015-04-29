# Set the API Access ID, Secret Key, and Base URL for the API
# Place the values within the single quotes. If your Secret Key has a single quote in it, you may need to escape it by using the backtick before the single quote
# I currently have not implemented any work with the Default Organization setting, but here is a place holder

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
	# Generate the HMAC Signature using API URI, Request Method, and Unix Time
	$HMACSignature = $HMACSHA256.ComputeHash([System.Text.Encoding]::UTF8.GetBytes("$URL`:$RequestMethod`:$Timestamp"))
	# Base 64 Encode the HMAC Signature
	$HMACBase64 = [System.Convert]::ToBase64String($HMACSignature)
	# Craft the full Authorization Header
	# Create a HashTable where we will add the Authorization information
	$Headers = New-Object System.Collections.Hashtable
	$Headers.Add("Timestamp",$Timestamp)
	$Headers.Add("Authorization",$Authorization)
	return $Headers
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
	
	# Check for Status=Success and print the results or the Error
	if ($Response.Status -eq "Success") {
		$Response.data.owner
	} else {
		Write-Error "API Request failed with the following error:`n $($Response.Status)"
	}
}





















