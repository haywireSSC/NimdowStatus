import os, strutils
import ../segment

const
  ## Battery Icons to display (array)
  BATTERY_ICONS = @["  ", "  ", "  ", "  ", "  ", "  "]

# get the current battery status and battery level of laptop
proc getBatStatus*(s: Segment): string =
  # Make sure we are running on a laptop with BAT0, change to BAT1 if needed
  if not fileExists("/sys/class/power_supply/BAT0/capacity"):
    return BATTERY_ICONS[1] & "N/A" #isEmpty
  else:
    # Read the first line of the these files

    let sBatStats = readLines("/sys/class/power_supply/BAT0/status", 1)
    let sCapacity = readLines("/sys/class/power_supply/BAT0/capacity", 1)

    # Check if battery status is in charging mode
    if sBatStats[0] == "Charging":
      s.icon = BATTERY_ICONS[0] #isPlg
    else:
      case parseInt(sCapacity[0]):
      of 10..35:
        s.icon = BATTERY_ICONS[2] #isLow
      of 36..59:
        s.icon = BATTERY_ICONS[3] #isHalf
      of 60..85:
        s.icon = BATTERY_ICONS[4] #is3Qrt
      of 86..100:
        s.icon = BATTERY_ICONS[5] #isFull
      else:
        s.icon = BATTERY_ICONS[1] #isEmpty
    # return the corresponding icon and battery level 
    return sCapacity[0] & "%"
