import os, osproc, strutils, times
import ../[segment, delay]

let archUpdatesDelay = initDelay(interval = initDuration(minutes = 10))
var archUpdatesText = ""

proc getArchUpdates*(s: Segment): string = 

  if fileExists("var/lib/pacman/db.lck"):
    s.color = GRUVBOX9
    return "UPDATING"
  else:
    s.color = GRUVBOX4
    if archUpdatesDelay.isUpdate() or archUpdatesText == "N/A":
      let updates = execProcess("checkupdates | wc -l")
      let sUpdates = if "ERROR" in updates:
        "N/A"
      else:
        updates[0 .. ^2]
      if sUpdates == "0":
        archUpdatesText = ""
      elif sUpdates == "N/A":
        archUpdatesText = sUpdates
      else:
        archUpdatesText = "Updates: " & sUpdates
    return archUpdatesText




  
