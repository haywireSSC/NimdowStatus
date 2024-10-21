import httpclient
import ../segment

proc getWeather*(s: Segment): string =
  var hClient = newHttpClient(timeout = 1000)
  result = hClient.getContent("http://wttr.in/Bristol?format=%t")
  hClient.close()
