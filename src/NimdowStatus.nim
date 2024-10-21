import os
import segment, delay, reconnect
import functions/[alsa, archUpdates, batStatus, dateTime, keyboard, lesson, memory, weather, bluetooth, wifi]
#getAlsa, getArchUpdates, getBatStatus, getDateTime, getKeyboard, getNextLesson, getMemory, getWeather
#memoryicon
#keyboardicon
## date icon to display
#DATE_ICON = "  "
## time icon to display
#TIME_ICON = "  "
type
  Bar = ref object
    segments: seq[Segment]
    text: string

proc setStatus(status: string) =
  discard execShellCmd("xsetroot -name " & "\"" & status & "\"")

proc update(s: Bar, isUpdateAll: bool = false) = 
  s.text = ""
  for segment in s.segments:
    segment.update(isUpdateAll)
    s.text &= segment.text
  setStatus(s.text)

proc initBar(segments: seq[Segment]): Bar = 
  result = Bar.new
  result.segments = segments

let
  connectChecker = initConnectChecker()
  sAlsa = initSegment(color = GRUVBOX6, body = getAlsa)
  sArchUpdates = initSegment(icon = "", body = getArchUpdates)
  sBatStatus = initSegment(color = GRUVBOX5, body = getBatStatus, interval = initDuration(seconds = 2))
  sDateTime = initSegment(icon = "", color = GRUVBOX3, body = getDateTime)
  sWeather = initSegment(icon = "", color = GRUVBOX9, body = getWeather, interval = initDuration(minutes = 10))
  sLesson = initSegment(icon = "", body = getLesson, interval = initDuration(minutes=10))
  sBluetooth = initSegment(icon = "", color = GRUVBOX4, body = getBluetooth, interval = initDuration(seconds = 5))
  sWifi = initSegment(isShowAlways = true, color = GRUVBOX13, body = getWifi, interval = initDuration(seconds = 2))

  bar = initBar(segments = @[sLesson, sBluetooth, sWifi, sAlsa, sArchUpdates, sBatStatus, sDateTime, sWeather])

while true:
  bar.update(connectChecker.hasReconnected())

#reset delays when wifi connected