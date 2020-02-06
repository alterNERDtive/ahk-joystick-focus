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
; Make sure your % file file is setup properly. If not you might
; have to go kill the script from Task Manager :)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#NoEnv

sendMode Input
setWorkingDir %A_ScriptDir%

#SingleInstance force
#MaxThreadsPerHotkey 1

#InstallKeybdHook

#Persistent

; read focus.ini
config := readConfig("focus.ini")

; set the target watcher
SetTimer, watchTarget, % config["polling"]["targetcheckrate"]

; reads the config file
readConfig(file) {
  config := []

  ; [target]
  IniRead, tname, % file, target, name
  config["target"] := {"name": tname}

  ; [polling]
  IniRead, prate, % file, polling, pollingrate
  IniRead, tcrate, % file, polling, targetcheckrate
  config["polling"] := {"pollingrate": prate, "targetcheckrate": tcrate}

  ; [devices]
  IniRead, thold, % file, devices, threshold
  names := []
  error := False
  while (!error) {
    IniRead, tmp, % file, devices, name%A_Index%
    if (tmp == "ERROR")
      error := True
    else
      names.push(tmp)
  }
  senses := []
  error := False
  while (!error) {
    IniRead, tmp, % file, devices, sensitivity%A_Index%
    if (tmp == "ERROR")
      error := True
    else
      senses.push(tmp)
  }
  config["devices"] := {"threshold": thold, "names": names, "sensitivities": senses}

  ; [tools]
  IniRead, tkill, % file, tools, kill
  paths := []
  error := False
  while (!error) {
    IniRead, tmp, % file, tools, path%A_Index%
    if (tmp == "ERROR")
      error := True
    else
      paths.push(tmp)
  }
  config["tools"] := {"kill": tkill, "paths": paths}

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
  if (WinExist("ahk_exe " config["target"]["name"])) {
    ; start stick watcher
    rate := config["polling"]["pollingrate"]
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
          Process, Close, % file
        }
      }
    }
  }
return

; this one will check the sticks for input on the X/Y axes or buttons
; if an axis is currently active or a button down, focuses the target program
watchSticks:
  target := "ahk_exe " config["target"]["name"]
  ; poll all axes
  for id, dev in config["devices"]["names"] {
    for ia, axis in [ "X", "Y" ] {
      ; axes are 0-100
      ; -50 means we get a deviation from "0" aka resting state
      ; abs() since we don’t care which direction you push the thing
      if (abs(getKeyState(dev axis) - 50)
            * config["devices"]["sensitivities"][id]
          > config["devices"]["threshold"]) {
        ; focus the target!
        WinActivate, % target
      }
    }
  }
  ; check ALL THE BUTTONS!
  for id, dev in config["devices"]["names"] {
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
return
