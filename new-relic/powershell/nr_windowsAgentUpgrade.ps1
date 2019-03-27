#region Top of Script

#requires -version 3
<#

.SYNOPSIS 
    String

.DESCRIPTION 
    String

.NOTES
    Version:        1.0
    Author:         Zack Mutchler
    Creation Date:  March 1, 2019
    Purpose/Change: Initial script development
    
    Version:        1.1
    Author:         Zack Mutchler
    Creation Date:  March 25, 2019
    Purpose/Change: Updated logfile and console output
    
    Version:        1.2
    Author:         Zack Mutchler
    Creation Date:  March 25, 2019
    Purpose/Change: Removed /qn argument from msiexec.exe
  
#>

#endregion

#####-----------------------------------------------------------------------------------------#####

#region Variables

# Set the download URL for the latest version
$downloadURL = 'https://download.newrelic.com/infrastructure_agent/windows/newrelic-infra.msi'

# Set the save file location for the downloaded MSI
$msiSave = $env:USERPROFILE + '\nrWinUpdate.msi'

#endregion Variables

#####-----------------------------------------------------------------------------------------#####

#region Pre-Work

# Start the transcript
$logFile = $env:USERPROFILE + '\nrInfraUpdate_' + ( Get-Date -Format MM-dd-yyyy_HHmm ) + ".log"
Start-Transcript -Path $logFile -Force 

#endregion Pre-Work

#####-----------------------------------------------------------------------------------------#####

#region Execution

# Grab the currently installed version
$installed = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -eq 'New Relic Infrastructure Agent' }
Write-Host "Currently Installed Version: $( $installed.Version)" -ForegroundColor Cyan

# Download the installer
Invoke-WebRequest -Uri $downloadURL -OutFile $msiSave 

# Start the installer, quietly
msiexec.exe /i $msiSave 

# Wait 30 seconds for the installer, and start the New Relic Infrastructure Agent Service
Write-Host "Waiting 30 seconds..."
Start-Sleep -Seconds 30
Start-Service -Name newrelic-infra

# Wait another 30 seconds, to make sure the service has time to start
Write-Host "Waiting 30 seconds..."
Start-Sleep -Seconds 30

# Grab the current service details
$service = Get-Service -Name newrelic-infra

# Get the details of the agent install
$upgraded = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -eq 'New Relic Infrastructure Agent' }

# Write our results to console
Write-Host "$( $service.Name ) is currently: $( $service.Status )`nVersion: $( $upgraded.Version)" -ForegroundColor Green

# Stop the transcript
Stop-Transcript

#endregion Execution
