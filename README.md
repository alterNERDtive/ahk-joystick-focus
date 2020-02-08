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
* when it’s up, watches configured devices for input and focuses the application 
  if you move the X/Y axis or hit a button

## Requirements

### Running from Source ##

If you have AutoHotKey (1.1.x) installed, you can just run the script from 
source. Obviously needs AutoHotKey installed.

### Using the Executable ##

If you don’t want to install AutoHotKey and/or want something that “just works”, 
there is [a compiled .exe on the releases 
page](https://github.com/alterNERDtive/ahk-joystick-focus/releases/latest).

## Settings ##

Before running the script for the first time, you need to create a `focus.ini` 
file or rename the included `focus.example.ini` to that. It contains my personal 
settings if you want to go off those as a base. Which is exactly what I’ll be 
doing here to explain things.

### Target Application ###

```
[target]
name="EliteDangerous64.exe"
```

The name of the executable the script should be monitoring for. In case of 
Elite: Dangerous, that is `EliteDangerous64.exe`.

### Polling Rates ###

```
[polling]
pollingrate=100
targetcheckrate=5000
```

`pollingrate` (in ms) here is the interval at which to check for input on the 
configured devices. `targetcheckrate` (also in ms) is the rate at which the 
script will check if the target application is running. This is less 
time-critical as it will probably take a couple seconds to fully start anyway.

The lower you set the polling rates, the more CPU it will cost to keep the 
script running in the background but also the snappier it will react to inputs. 
If you feel like 100 ms are too slow, set a delay that’s smaller.

### Device Settings ###

```
[devices]
device1="2Joy"
device2="4Joy"
device1sensitivity=10
device5useaxes=False
device6usebuttons=False
threshold=5
```

In this section of the config file you are defining the devices the script 
should be monitoring.

`device1` through `deviceX` are the device names in AHK terms, with `Joy` or 
`1Joy` being the first in the list. You’ll probably have to go through them in 
sequence to find out which physical device is which number. The ordering MIGHT 
change after you reboot the system but has been consistent for me so far. It 
should definitely change if you reboot with one of the devices unplugged. Make 
sure to number these sequentially as the script will stop looking at the first 
number that’s not set.

`deviceXsensitivity` is an (optional) multiplier used for the axis inputs of the 
device with the same number as above. If you do not have set any curves for your 
device(s), you should probably leave this at `1` for all of them (or just don’t 
put a setting into your config). Personally I have a very non-aggressive curve 
on my right stick, so that ones multiplier is cranked all the way up to `10`.

Similarly, `deviceXuseaxes` and `deviceXusebuttons` can be set to `False` to 
disable monitoring of certain devices’ axes or buttons. If you leave this out, 
it is assumed `True`.

Last but not least, `threshold` will be the intensity of input needed on an axis 
to trigger the script to focus your application. `5` means a 10% movement up or 
down an axis since the entire range of movement is `0` to `100`, with `50` being 
resting position. If your device is “wobbly” and needs a huge dead zone in order 
not to produce ghost inputs, you might have to increase this.

### Tools Settings ###

```
[tools]
tool1="C:\Program Files (x86)\EDMarketConnector\EDMarketConnector.exe"
tool2="D:\Tools\SSChanger\SSChanger.exe"
kill=True
```

Here you can set tools the script should run alongside your application.

`tool1` to `toolX` has to be set to the full paths of the tools’ executables. 
Make sure to number these sequentially as the script will stop looking at the 
first number that’s not set.

`kill` is a boolean (`True`/`False`) to tell the script whether to kill the 
tools again after your target application has shut down. If you want them to 
stay open, just set this to `False`.

## Need Help / Want to Contribute? ##

If you run into any errors, please look at the 
[devel](https://github.com/alterNERDtive/ahk-joystick-focus/tree/devel) branch 
and see if it’s fixed there already.

If you have no idea what I was saying in that last parargraph and / or it 
doesn’t fix your problem, please [file an 
issue](https://github.com/alterNERDtive/ahk-joystick-focus/issues). Thanks! :)

You can also [say “Hi” on Discord](https://discord.gg/mD6dAb) if that is your 
thing.
