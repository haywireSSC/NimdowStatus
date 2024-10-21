import times
export initDuration

type
  Delay* = ref object
    interval: Duration
    lasttime: DateTime

proc initDelay*(interval: Duration = initDuration(milliseconds = 500)): Delay = 
  result = Delay.new
  result.interval = interval
  result.lasttime = now() - interval

proc reset*(s: Delay) = 
  s.lasttime = now() - s.interval

proc isUpdate*(s: Delay): bool = 
  if s.lasttime + s.interval < now():
    s.lasttime = now()
    return true
  else:
    return false


