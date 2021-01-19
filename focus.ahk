;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This script will raise / focus a target application when you move
; your Joystick/Throttle/Gamepad/whatever axes or hit a button.
;
; I’m using it with twin sticks for Elite Dangerous, but it should be
; generically usable.
;
; It will also start a list of tools if the target application is
; detected and (optional, default on) close them again when the
; target is gone.
;
; Make sure your focus.ini file is setup properly. If not you might
; have to go kill the script from the systray or Task Manager :)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#NoEnv

sendMode Input
setWorkingDir %A_ScriptDir%

#SingleInstance force
#MaxThreadsPerHotkey 1

#InstallKeybdHook

#Persistent

; check for config file and exit if it doesn’t exist
if (!FileExist("focus.ini")) {
  msgbox, No config file found. Please follow the instructions in the README file.
  ExitApp, 1
}

; read focus.ini
config := readConfig("focus.ini")
state := {}

; set the target watcher
SetTimer, watchTarget, % config["polling"]["targetcheckrate"]

; reads the config file
readConfig(file) {
  config := []

  ; [target]
  IniRead, tname, % file, target, name
  config["target","name"] := tname

  ; [polling]
  IniRead, prate, % file, polling, pollingrate
  IniRead, tcrate, % file, polling, targetcheckrate
  config["polling"] := {"pollingrate": prate, "targetcheckrate": tcrate}

  ; [devices]
  IniRead, thold, % file, devices, threshold
  names := []
  error := False
  while (!error) {
    IniRead, tmp, % file, devices, device%A_Index%
    if (tmp == "ERROR")
      error := True
    else
      names.push(tmp)
  }
  devcount := names.MaxIndex()
  senses := []
  useAxes := []
  useButtons := []
  loop, %devcount%
  {
    IniRead, tmp, % file, devices, device%A_Index%sensitivity
    if (tmp == "ERROR")
      tmp := 1
    senses.push(tmp)
    IniRead, tmp, % file, devices, device%A_Index%useAxes
    if (tmp == "ERROR")
      tmp := True
    else
      tmp := %tmp%
    useAxes.push(tmp)
    IniRead, tmp, % file, devices, device%A_Index%useButtons
    if (tmp == "ERROR")
      tmp := True
    else
      tmp := %tmp%
    useButtons.push(tmp)
  }
  config["devices"] := {"threshold": thold, "names": names, "sensitivities": senses, "useAxes": useAxes, "useButtons": useButtons}

  ; [tools]
  IniRead, tkill, % file, tools, kill
  paths := []
  error := False
  while (!error) {
    IniRead, tmp, % file, tools, tool%A_Index%
    if (tmp == "ERROR")
      error := True
    else
      paths.push(tmp)
  }
  config["tools"] := {"kill": %tkill%, "paths": paths}

  return config
}

; nothing but jump labels beyond this point, let’s make it explicit
; (AHK v2 will finally get rid of those …)
return

; this one will check for a running target process
; if found
; 1. start the actual stick watching routine at a higher polling frequency
; 2. start ALL THE TOOLS
; if not found
; 1. stop the stick watching routine
; 2. (optional) stop ALL THE TOOLS
watchTarget:
  watchTarget()
return
watchTarget() {
  global config
  if (WinExist("ahk_exe " config["target"]["name"])) {
    ; start stick watcher
    SetTimer, watchSticks, % config["polling"]["pollingrate"]
    ; start tools
    for ip, path in config["tools"]["paths"] {
      SplitPath, path, file
      if (!WinExist("ahk_exe " file)) {
        Run, % path
      }
    }
  }
  else {
    ; stop stick watcher
    SetTimer, watchSticks, Delete
    ; stop tools
    if (config["tools"]["kill"]) {
      for ip, path in config["tools"]["paths"] {
        SplitPath, path, file
        if (WinExist("ahk_exe " file)) {
          WinClose
        }
      }
    }
  }
}

; this one will check the sticks for input on the X/Y axes or buttons
; if an axis is currently active or a button down, focuses the target program
watchSticks:
  watchSticks()
return
watchSticks() {
  global config, state
  target := "ahk_exe " config["target"]["name"]
  ; poll all axes
  for id, dev in config["devices"]["names"] {
    ; check if axes are enabled for this device
    if (config["devices"]["useAxes"][id]) {
      for ia, axis in [ "X", "Y", "Z", "R", "U", "V" ] {
        if (abs(getKeyState(dev axis) - state[id][axis])
            * config["devices"]["sensitivities"][id]
            > config["devices"]["threshold"]) {
          ; focus the target!
          WinActivate, % target
        }
        state[id, axis] := getKeyState(dev axis)
      }
    }
  }
  ; check ALL THE BUTTONS!
  for id, dev in config["devices"]["names"] {
    ; check if buttons are enabled for this device
    if (config["devices"]["useButtons"][id]) {
      ; get button count for the device and loop over all of them
      buttons := getKeystate(dev "Buttons")
      Loop, %buttons%
      {
        if (getKeyState(dev A_Index)) {
          ; focus the target!
          WinActivate, % target
        }
      }
    }
  }
}
