#region Top of Script

#requires -version 3
<#

.SYNOPSIS 
    Summary of purpose

.DESCRIPTION 
    Reference links and details

.NOTES
    Version:        1.0
    Author:         Zack Mutchler
    Creation Date:  March 1, 2019
    Purpose/Change: Initial script development
  
#>

#endregion

#####-----------------------------------------------------------------------------------------#####

#region Script Parameters

Param( 

    [ parameter( Mandatory = $true, HelpMessage = "This is help text for mandatory parameters." ) ]
        [ alias( 'acronym', 'shortName' ) ]
        [ ValidateSet( "option1", "option2" ) ]
        [ ValidateNotNullOrEmpty() ]
        [ string ] 
        $paramA,

    [ parameter( Mandatory = $false ) ]
        [ alias( 'acronym', 'shortName' ) ]
        [ ValidateNotNullOrEmpty() ]
        [ integer ] 
        $paramB

)

#endregion Script Parameters

#####-----------------------------------------------------------------------------------------#####

#region Pre-Work

# Start the transcript
$logFile = $env:USERPROFILE + '\orionPrep_' + ( Get-Date -Format MM-dd-yyyy_HHmm ) + ".log"
Start-Transcript -Path $logFile -Force 

# Start the stopwatch
$stopWatch = [ System.Diagnostics.Stopwatch ]::StartNew()

#endregion Pre-Work

#####-----------------------------------------------------------------------------------------#####

#region Variables



#endregion Variables

#####-----------------------------------------------------------------------------------------#####

#region Execution



#endregion Execution

#####-----------------------------------------------------------------------------------------#####

#region Cleanup

# Stop the timer
$stopWatch.Stop()
Write-Host "`nSCRIPT DURATION: $( $stopWatch.Elapsed.Minutes ) min $( $stopWatch.Elapsed.Seconds ) sec" -ForegroundColor Yellow

# Stop the trainscript
Stop-Transcript 

#endregion Cleanup
