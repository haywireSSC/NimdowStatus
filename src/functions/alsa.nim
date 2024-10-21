import osproc, strutils
import ../segment

const
  ## Volume icon to display
  VOL_ICON = "  "
  ## Mute icon to display
  MUTE_ICON = " 󰖁 "

proc getAlsa*(s: Segment): string = 
  let sAlsaVol = execProcess("amixer get Master")
  if sAlsaVol.contains("off"):
    s.icon = MUTE_ICON
    return sAlsaVol[succ(sAlsaVol.find("["))..pred(sAlsaVol.find("]"))]
  else:
    s.icon = VOL_ICON
    return sAlsaVol[succ(sAlsaVol.find("["))..pred(sAlsaVol.find("]"))]
   
