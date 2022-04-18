Function Set-WindowSize {
    Param([int]$x=$host.ui.rawui.windowsize.width,
          [int]$y=$host.ui.rawui.windowsize.heigth)
    
        $size=New-Object System.Management.Automation.Host.Size($x,$y)
        $host.ui.rawui.WindowSize=$size	
     
    }
    Set-WindowSize 109 43




############## SMTP VARIABLES ###############
#############################################
$smtp = "relay.ad.utah.edu"
$to = ("rory.campbell@hsc.utah.edu", "kelly.mcmullen@hsc.utah.edu")
$sub = "Quartz Scheduler is Down"
$body = "Log into EpicTapPROC16. Check and make sure the Quartz Scheduler is running"
$From = "QuartzAlert@hsc.uta.edu"
############## SMTP VARIABLES ###############
#############################################




############# SET COLOR OUTPUT ##############
#############################################
function Write-ColorOutput($ForegroundColor)
{
    # save the current color
    $fc = $host.UI.RawUI.ForegroundColor

    # set the new color
    $host.UI.RawUI.ForegroundColor = $ForegroundColor

    # output
    if ($args) {
        Write-Output $args
    }
    else {
        $input | Write-Output
    }

    # restore the original color
    $host.UI.RawUI.ForegroundColor = $fc
}
############# SET COLOR OUTPUT ##############
#############################################



CLS

Write-Host "=============================================================================================================
=============================================================================================================


                                 Starting Quartz Scheduler. This window will 
                                 stay open and make sure the app is running.


=============================================================================================================
=============================================================================================================
"
Start-Sleep -Seconds 45
Do
{
$Quartz = "QuartzScheduler.Worker"
Start-Process "C:\csharp-apps\QuartzScheduler\QuartzScheduler.Worker.exe"
Start-Sleep -Seconds 1


if((get-process $Quartz -ea SilentlyContinue) -eq $Null)
    {
    filter timestamp {"$(Get-Date -Format G): $_"}
    Write-Output "    QuartzScheduler is not running. Attempting to open..." | timestamp | Write-ColorOutput Red
    Start-Sleep -Seconds 5
    Send-MailMessage -SmtpServer $smtp -To $to -Subject $Sub -Body $Body -From $From
    Start-Process "C:\csharp-apps\QuartzScheduler\QuartzScheduler.Worker.exe"
    Start-Sleep -Seconds 44
    }

else{
filter timestamp {"$(Get-Date -Format G): $_"}
    Write-Output "    QuartzScheduler is running." | timestamp | Write-ColorOutput Green
    Start-Sleep -Seconds 299
    }

}
Until ((get-process $Quartz -ea SilentlyContinue) -eq $True)