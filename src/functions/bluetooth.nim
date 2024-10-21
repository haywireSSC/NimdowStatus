import osproc, strutils
import ../[segment]

proc getBluetooth*(s: Segment): string = 
  let isOn = execCmd("bluetoothctl -- show | grep \"Powered: yes\"") == 0
  s.isShowAlways = isOn
  execProcess("bluetoothctl -- devices Connected | cut -c 26-")[0 .. ^2].splitLines().join(", ")