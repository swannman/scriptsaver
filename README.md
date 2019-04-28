# ScriptSaver

## What is ScriptSaver?

ScriptSaver is a Mac OS X screen saver which executes AppleScripts when it is activated and/or deactivated. For example, ScriptSaver can pause iTunes when the screensaver is activated, then unpause it when you return to the computer. It's limited only by what AppleScripts you write!

Double-click on ScriptSaver.saver to install it. Alternatively, drag ScriptSaver.saver to the Screen Savers folder inside the Library folder in your home folder.

## Configuring ScriptSaver
Select ScriptSaver in the "Desktop & Screen Saver" preference pane in System Preferences and click the "Options\'85" button to display the ScriptSaver configuration sheet.

To execute an AppleScript when the screensaver activates, click the button labeled "Choose" in the "Activation Script" section of the configuration sheet. Select an AppleScript from the Open dialog that appears.

Please note that your AppleScript must have the file extension .scpt or .applescript to be chosen in the open panel. 
This script will execute when the screensaver is activated.

To execute an AppleScript when the screensaver deactivates, select a script in the "Deactivation Script" section of the configuration sheet. This AppleScript will execute when the user moves the mouse or presses a key to cancel the screensaver.

The "Screen Saver" section allows you to choose a screen saver to run after the activation AppleScript has been launched. Screensavers installed in /System/Library/Screen Savers appear at the top of the list, followed by screensavers that exist in the current user's Library/Screen Savers folder. ScriptSaver supports Quartz Composer (.qtz) and ScreenSaverView (.saver) screensavers. If "None" is selected, the Desktop will be visible while the screensaver is active.

## Advanced Options
Scripts may be run synchronously or asynchronously. Synchronous scripts don't allow the chosen screensaver to start until they have finished, while asynchronous scripts execute in the background while the screensaver is displayed. Note that Mac OS X may kill asynchronous scripts when the screensaver is activating or deactivating — these may not work as expected.

If your AppleScript needs user input — for example, if it displays an alert dialog — it should be run synchronously.

If the "Show desktop while synchronous scripts execute" checkbox is selected, ScriptSaver will show the Desktop while a synchronous activation or deactivation script is running. This can be useful if your script displays messages or dialog boxes to the user.

## Example: Using the iTunes Visualizer as a screensaver
Set the Activation Script to ShowiTunesVisualizer.scpt and the Deactivation Script to HideiTunesVisualizer.scpt. Uncheck both "Run asynchronously" checkboxes, and select "Show desktop while synchronous scripts execute". Set the Screensaver to "None (show desktop)".

## Known Issues
Some screensavers (e.g. Flurry) do not display correctly under ScriptSaver.

Older versions of Mac OS X allowed the user to force a logout by killing the LoginWindow process. This is no longer possible in 10.6+.

If the user deactivates the screensaver but enters the wrong password, the activation / deactivation scripts will be run again. The activation script executes every time the screensaver starts over (e.g. after a failed password entry), and the deactivation script executes every time the user attempts to cancel the screensaver (e.g. by moving the mouse or pressing a key). Keep this in mind when writing your AppleScripts.