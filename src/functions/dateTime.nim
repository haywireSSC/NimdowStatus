import times
import ../segment

const
  ## date formatting
  DATE_FORMAT = "ddd d MMM "
  ## time formatting
  TIME_FORMAT = "HH:mm "
  ## date and time formatting
  DATETIME_FORMAT = "ddd d MMM HH:mm "

# get the date and time
proc getDateTime*(s: Segment): string =
  result = format(now(), DATETIME_FORMAT)

proc getDate*(): string =
  result = format(now(), DATE_FORMAT)

proc getTime*(): string =
  result =  format(now(), TIME_FORMAT)
