import sugar, times, os

const
  RESET: string  = "\x1b[0m"
  FG: string = "\x1b[38;2;"
  BG: string = "\x1b[48;2;"
  ## Regions for clickable statusbar
  REGION: string = "\x1F" # Do not edit, use Nimdows config.toml to set actions

  GRUVBOX0: string  = "40;40;40m"     #282828
  GRUVBOX1: string  = "204;36;29m"    #cc241d
  GRUVBOX2: string  = "152;151;26m"   #98971a
  GRUVBOX3: string  = "215;153;33m"   #d79921
  GRUVBOX4: string  = "69;133;136m"   #458588
  GRUVBOX5: string  = "177;98;134m"   #b16286
  GRUVBOX6: string  = "104;157;106m"  #689d6a
  GRUVBOX7: string  = "168;153;132m"  #a89984
  GRUVBOX8: string  = "146;131;116m"  #928374
  GRUVBOX9: string  = "251;73;52m"    #fb4934
  GRUVBOX10: string = "184;187;38m"   #b8bb26
  GRUVBOX11: string = "250;189;47m"   #fabd2f
  GRUVBOX12: string = "131;165;152m"  #83a598
  GRUVBOX13: string = "211;134;155m"  #d3869b
  GRUVBOX14: string = "142;192;124m"  #8ec07c
  GRUVBOX15: string = "235;219;178m"  #ebdbb2

type
  Sides = enum
    PLine = (left: "", right: "")
    CLine = (left: "", right: "")
    ALine = (left: "", right: "")
    Arrow = (left: "", right: "")
    Circle = (left: "", right: "")
    Angle = (left: "", right: "")

  Segment = ref object
    sides: Sides
    color: string
    body: () -> string
    text: string
    lasttime: DateTime
    interval: Duration

  Bar = ref object
    segments: openArray[Segment]
    text: string

proc checkUpdate(s: Segment) = 
  if lasttime + interval > now():
    s.update()

proc update(s: Sement) = 
  s.text = if s.sides.right == "":
    (FG&s.color & s.sides.left & RESET & BG&s.color) + s.body() + REGION
  else:
    (RESET & FG&s.color & s.sides.left & RESET & BG&s.color) + s.body() + REGION + (RESET & FG&s.color & s.sides.right & RESET)

proc setStatus(sStatus: string) =
  discard execShellCmd("xsetroot -name " & "\"" & sStatus & "\"")

proc update(s: Bar) = 
  s.text = ""
  for segment in s.segments:
    segment.checkUpdate()
    s.text += segment.text
  setStatus(s.text)

let bar = Bar.new
while True:
  bar.update()

  