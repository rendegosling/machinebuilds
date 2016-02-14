# Boxstarter options
$Boxstarter.RebootOk=$true # Allow reboots?
$Boxstarter.NoPassword=$false # Is this a machine with no login password?
$Boxstarter.AutoLogin=$true # Save my password securely and auto-login after a reboot

#### .NET 3.5 ####

cinst dotnet3.5 -y # Not automatically installed. Includes .NET 2.0. Uses Windows Features to install.
if (Test-PendingReboot) { Invoke-Reboot }

#### WINDOWS SETTTINGS #####

# Basic setup
Update-ExecutionPolicy Unrestricted
Set-ExplorerOptions -showFileExtensions
#Enable-RemoteDesktop
Disable-InternetExplorerESC
#Disable-UAC
#Set-TaskbarSmall

# disable defrag because I have an SSD
Get-ScheduledTask -TaskName *defrag* | Disable-ScheduledTask

################################# POWER SETTINGS #################################

# Turn off hibernation
# powercfg /H OFF

# Change Power saving options (ac=plugged in dc=battery)
powercfg -change -monitor-timeout-ac 0
powercfg -change -monitor-timeout-dc 15
powercfg -change -standby-timeout-ac 0
powercfg -change -standby-timeout-dc 30
powercfg -change -disk-timeout-ac 0
powercfg -change -disk-timeout-dc 30
powercfg -change -hibernate-timeout-ac 0

## When docked - Make sure that when I close the lid of my laptop it doesn't go to sleep

# retrieve the current power mode Guid
$guid = (Get-WmiObject -Class win32_powerplan -Namespace root\cimv2\power -Filter "isActive='true'").InstanceID.tostring() 
$regex = [regex]"{(.*?)}$" 
$guidVal = $regex.Match($guid).groups[1].value #$regex.Match($guid) 
# Write-Host $guidVal
# Set close the lid power option to 'Do Nothing' for plugged in.
powercfg -SETACVALUEINDEX $guidVal 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 0
#To see what other options are available - run the following:
# powercfg -Q $guidVal

################################# SOFTWARE #######################################

#Browsers
cinst googlechrome -y
cinst firefox -y

#Other dev tools
cinst cygwin -y
cinst git -y
cinst curl -y
cinst ruby -y
cinst ruby2.devkit -y
cinst fiddler4 -y
cinst brackets -y
cinst visualstudiocode -y
cinst atom -y
cinst notepadplusplus -y
cinst nodejs.install -y
cinst sourcetree -y
#cinst python2 -y
#cinst tortoisesvn -y

#Other essential tools
cinst 7zip -y
cinst adobereader -y
cinst skype -y
cinst dropbox -y
cinst windirstat -y
cinst virtualbox -y
cinst vagrant -y
cinst ccleaner -y
#cinst genymotion -y # use Xamarin player instead?
choco install jdk8 -y
#choco install maven -y # This package installs into C:/bin which is too annoying 
cinst join.me -y
cinst slack -y
cinst clover -y # windows explorer tabs
cinst launchy -y

#Not on Choco


Install-ChocolateyPinnedTaskBarItem "$($Boxstarter.programFiles86)\Google\Chrome\Application\chrome.exe"
#Install-ChocolateyPinnedTaskBarItem "$($Boxstarter.programFiles86)\Microsoft Visual Studio 12.0\Common7\IDE\devenv.exe"

# Update Windows and reboot if necessary
Install-WindowsUpdate -AcceptEula -GetUpdatesFromMS
if (Test-PendingReboot) { Invoke-Reboot }