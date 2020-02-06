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
