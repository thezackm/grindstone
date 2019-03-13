#region Top of Script

#requires -version 3
<#

.SYNOPSIS 
    Searches target certificate stores for certificates matching name pattern  

.DESCRIPTION 
    Uses a -like operator
    This version looks for the Geotrust and Digitcert certs used by New Relic Infrastructure Agent

.NOTES
    Version:        1.0
    Author:         Zack Mutchler
    Creation Date:  March 12, 2019
    Purpose/Change: Initial Script development
  
#>

#endregion

#####-----------------------------------------------------------------------------------------#####

#region Variables

# Set our output CSV location
$savePath = 'D:\TEMP\' + $env:COMPUTERNAME + '.csv'

# Annotate the target stores
$stores = @( 'Cert:\LocalMachine\Root','Cert:\LocalMachine\TrustedPublisher','Cert:\LocalMachine\CA' )
<#
    TrustedPublisher [Trusted Publishers]
    ClientAuthIssuer [Client Authentication Issuers]
    Remote Desktop [Remote Desktop]
    Root [Trusted Root Certification Authorities]
    TrustedDevices [Trusted Devices]
    CA [Third-Party Root Certification Authorities]
    WebHosting [Web Hosting]
    SMS [SMS]
    AuthRoot [Intermediate Certification Authorities]
    TrustedPeople [Trusted People]
    My [Personal]
    SmartCardRoot [Smart Card Trusted Roots]
    Trust [Enterprise Trust]
    Disallowed [Untrusted Certificates]
#>

# Create an empty array to hold our results
$results = @()

#endregion Variables

#####-----------------------------------------------------------------------------------------#####

#region Execution

foreach ( $s in $stores ) {

    Write-Host "$s" -ForegroundColor Cyan
    
	Set-Location -Path $s 
    
	$certs = Get-ChildItem | Where-Object { $_.DnsNameList.Unicode -like '*geo*' -or $_.DnsNameList.Unicode -like '*digi*' }
        
        foreach ( $c in $certs ) {

            $item = New-Object -TypeName psobject 
            $item | Add-Member -MemberType NoteProperty -Name 'store' -Value $s
            $item | Add-Member -MemberType NoteProperty -Name 'name '-Value $c.DnsNameList.Unicode
            $item | Add-Member -MemberType NoteProperty -Name 'issuer' -Value $c.Issuer

            $results += $item

        }
}

$results | Export-Csv -NoTypeInformation -Path $savePath

#endregion Execution
