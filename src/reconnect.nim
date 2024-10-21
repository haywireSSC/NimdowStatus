import osproc, delay

type
  ConnectChecker = ref object
    delay: Delay
    wasOnline: bool

proc getIsOnline(): bool = 
  execCmd("ping -q -c1 archlinux.org &>/dev/null") == 0

proc initConnectChecker*(): ConnectChecker = 
  result = ConnectChecker.new
  result.delay = initDelay(initDuration(seconds = 5))

proc hasReconnected*(s: ConnectChecker): bool = 
  if s.delay.isUpdate():
    let isOnline = getIsOnline()
    if isOnline and not s.wasOnline:
      result = true
    s.wasOnline = isOnline
