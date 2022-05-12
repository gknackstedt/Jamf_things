#!/bin/bash
###############################
#
# Jamf_Connect_LaunchAgent_Uninstall - v2.sh
# Checks for Jamf Connect related LaunchAgents, if found unloads and deletes them.
# 5.12.2022
# v2.0
# Greg Knackstedt
# https://github.com/scriptsandthings/
# 
# - Based on the Jamf provided Jamf Connect Uninstaller.pkg written by Matthew Ward and Sameh Sayed.
# - A more complete removal of additional Jamf Connect related launch agents then my original attempt.
#
###############################
# 
# Quit Connect if running 
ConnectProcess=$(pgrep 'Jamf Connect')

if [ $ConnectProcess > 0 ]; then
    kill $ConnectProcess
fi

/usr/bin/logger 'Killing Jamf Connect processes'

# Variables
/usr/bin/logger 'starting script'
SyncLA='/Library/LaunchAgents/com.jamf.connect.sync.plist'
VerifyLA='/Library/LaunchAgents/com.jamf.connect.verify.plist'
Connect2LA='/Library/LaunchAgents/com.jamf.connect.plist'
ConnectULA='/Library/LaunchAgents/com.jamf.connect.unlock.login.plist'


# Find if there's a console user or not. Blank return if not.

consoleuser=$( scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }' )

# get the UID for the user

uid=$(/usr/bin/id -u "$consoleuser")
/usr/bin/logger ''''
/usr/bin/logger 'Console user is '"$consoleuser"', UID: '"$uid"''


# disable and remove LaunchD components

if [ -f "$SyncLA" ]; then
	/bin/echo ''''
    /bin/echo "Jamf Connect Sync Launch Agent is present. Unloading & removing.."
    /bin/launchctl bootout gui/"$uid" "$SyncLA"
    /bin/rm -rf "$SyncLA"
        else 
    /bin/echo "Jamf Connect Sync launch agent not installed"
fi

if [ -f "$VerifyLA" ]; then
	/bin/echo ''''
    /bin/echo "Jamf Connect Verify Launch Agent is present. Unloading & removing.."
    /bin/launchctl bootout gui/"$uid" "$VerifyLA"
    /bin/rm -rf "$VerifyLA"
        else 
    /bin/echo "Jamf Connect Verify launch agent not installed"
fi

if [ -f "$Connect2LA" ]; then
	/bin/echo ''''
    /bin/echo "Jamf Connect 2 Launch Agent is present. Unloading & removing.."
    /bin/launchctl bootout gui/"$uid" "$Connect2LA"
    /bin/rm -rf "$Connect2LA"
        else 
    /bin/echo "Jamf Connect 2 launch agent not installed"
fi

if [ -f "$ConnectULA" ]; then
	/bin/echo ''''
    /bin/echo "Jamf Connect Unlock Launch Agent is present. Unloading & removing.."
    /bin/launchctl bootout gui/"$uid" "$ConnectULA"
    /bin/rm -rf "$ConnectULA"
        else 
    /bin/echo "Jamf Connect Unlock launch agent not installed"
fi
/bin/echo ''''

/bin/echo "Jamf Connect LaunchAgents removed"

exit 0
