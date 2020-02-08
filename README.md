# AHK Script to Focus a Program Automatically on Joystick Input #

Personally I’m using it for Elite: Dangerous, but it’s generic in nature and you 
can use it for whatever thing you want.

I made it as a replacement for 
[ED:Runner](https://forums.frontier.co.uk/threads/ed-runner-a-help-program-for-vr-headsets-with-joysticks-hotas-part-2.440760/) 
because that a) needs to be run as Admin and I don’t like that and b) it kept 
randomly and silently crashing on me, defeating its purpose.

## Features ##

* runs in the background and watches for the configured application
* starts tools you need with the application when it’s up
* (optional) kills the tools again when it’s down
* when it’s up, watches configured devices for inputs and focuses the 
  application if you move the X/Y axis or hit a button

## Requirements

### Running from Source ##

If you have AutoHotKey (1.1.x) installed, you can just run the script from 
source. Obviously needs AutoHotKey installed.

### Using the Executable ##

If you don’t want to install AutoHotKey and/or want something that “just works”, 
there is [a compiled .exe on the releases page](/releases).

## Settings ##

FIXXME

[target]
; target program to set focus to
name="EliteDangerous64.exe"

[polling]
; (in ms)
; the lower you set this, the more CPU it will use and the faster/snappier it will react to joystick input
pollingrate=100
; how often to check for target program running
; this is way less time-critical since it will take a while to load anyway
targetcheckrate=5000

[devices]
; intensity of axis movement required to pop focus to the target (5 = 10% movement from center)
threshold=5
; set these to the correct devices for your sticks/HOTAS
; MIGHT change on reboot, but has been consistent for me so far
name1="2Joy"
name2="4Joy"
; if you have different curves on the sticks, adjust effective sensitivity here
; (same order as devices)
sensitivity1=10
sensitivity2=1

[tools]
; tools to run
path1="C:\Program Files (x86)\EDMarketConnector\EDMarketConnector.exe"
path2="D:\Tools\SSChanger\SSChanger.exe"
; whether to kill them when target program shuts down
kill=True

## Need Help / Want to Contribute? ##

If you run into any errors, please try running the profile in question on its 
own / get a fresh version. If that doesn’t fix the error, look at the 
[devel](https://github.com/alterNERDtive/ahk-joystick-focus/tree/devel) branch 
and see if it’s fixed there already.

If you have no idea what I was saying in that last parargraph and / or the 
things mentioned there don’t fix your problem, please [file an 
issue](https://github.com/alterNERDtive/ahk-joystick-focus/issues). Thanks! :)

You can also [say “Hi” on Discord](https://discord.gg/mD6dAb) if that is your 
thing.
