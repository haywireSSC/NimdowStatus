import osproc, strutils
import ../[segment]

const
  WIFI_ICON = ""
  ETHERNET_ICON = ""
  DISCONNECTED_ICON = ""

proc getWifi*(s: Segment): string = 
  let hasEthernet = "--" notin execProcess("nmcli -f TYPE,DEVICE connection | grep ethernet")[0 .. ^7]
  if hasEthernet:
    s.icon = ETHERNET_ICON
    return ""
  else:
    let wifis = execProcess("nmcli -f IN-USE,SIGNAL,SSID device wifi | grep \"*\"")
    if wifis != "":
      s.icon = WIFI_ICON
      let
        strength = wifis[8 .. 11].strip.parseInt
        wifi = wifis[12 .. ^1].strip
      return wifi
    else:
      s.icon = DISCONNECTED_ICON
      return ""