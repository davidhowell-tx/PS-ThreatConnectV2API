<#
Author: David Howell  @DavidHowellTX
Last Modified: 05/10/2015
Version: 1

Thanks to Threat Connect for their awesome documentation on how to use the API.
#>

# Get a list of all the included scripts and import them
Get-ChildItem -Filter *.ps1 -Recurse | ForEach-Object { Import-Module $_.FullName }

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