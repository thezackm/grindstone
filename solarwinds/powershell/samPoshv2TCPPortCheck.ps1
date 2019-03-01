#region Top of Script

#requires -version 2
<#
.SYNOPSIS 
    Attempts to connect to a remote TCP Port

.DESCRIPTION 
    Designed for use with SolarWinds SAM 6.4

.NOTES
    Version:        1.0
    Author:         Zack Mutchler
    Creation Date:  September 13, 2017
    Purpose/Change: Initial Script development.  
#>

#endregion

#####-----------------------------------------------------------------------------------------#####

#region Where am I?

# Check to see if this is running from within Orion by investigating the ${IP} variable from SAM
# If it is local execution, prompt for variables.
# If using SAM, pull variables from the Script Arguments field
IF( -not ${IP} ) {
    $isOrion = $false
    $remoteIP = Read-Host -Prompt "What is the Remote IP Address?"
    $remotePort = Read-Host -Prompt "What is the Remote TCP Port?"
}

ELSE {
    $isOrion = $true
    $remoteIP = $args[0]
    $remotePort = $args[1]
}

#endregion

#####-----------------------------------------------------------------------------------------#####

#region Script Body

# Create a new TcpClient class object for testing
$socket = New-Object -TypeName System.Net.Sockets.TcpClient

# We're using a Try/Catch block here to make sure our PowerShell version can load the Net.Sockets.TcpClients class
TRY
{
    $socket.Connect( $remoteIP, $remotePort )

    #Capture our results if the connection works
    If( $socket.Connected ) {
        # Close the connection
        $socket.Close()

        # These two messages are for SolarWinds SAM Execution
        Write-Host "Message: Port $($remotePort) on $($remoteIP) is open"
        Write-Host "Statistic: 1"
        
        # This variable holds the Exit Code for the Finally section
        $exitCode = 0
    }
}

# Here, we are catching errors that would have caused the Try section to fail.
# This is EXTREMELY helpful in SAM because the error messages there tend to be vague.
CATCH
{
    # These two messages are for SolarWinds SAM Execution
    Write-Host "Message: ERROR: $($Error[0])"
    Write-Host "Statistic: 0"
        
    # This variable holds the Exit Code for the Finally section
    $exitCode = 1
}

# Here we are going to use the $exitCode variable we have set above
FINALLY
{
    # If the script is being run in SAM, exit
    IF ($isOrion)
    {
        EXIT $exitCode
    }
    
    # If the script isn't being run in SAM, print the exit code, but don't exit
    ELSE
    {
        Write-Host "Not running in SAM" -ForegroundColor Yellow
        Write-Host "Exit Code: $exitCode (0 = Up, 1 = Down)" -ForegroundColor Yellow
    }
}
#endregion
