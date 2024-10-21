import httpclient, times, tables, json
import ../segment

var
  client = newHttpClient()

  LESSON_NAMES = {
    "Extended project": "EPQ",
    "Computer Programming": "Comp Sci",
    "Maths": "Maths",
    "FM": "FM",
    "Physics": "Physics"
  }.toTable

  LESSON_COLORS = {
    "EPQ": GRUVBOX3,
    "Comp Sci": GRUVBOX6,
    "Maths": GRUVBOX4,
    "FM": GRUVBOX9,
    "Physics": GRUVBOX5
  }.toTable

proc login() = 
  var data = newMultipartData()
  data["code"] = "LTKP6F86RQ"
  data["dob"] = "2007-10-18"
  let res = client.postContent("https://www.classcharts.com/apiv2student/login", multipart=data).parseJson
  client.headers = newHttpHeaders({"Authorization": "Basic " & res["meta"]["session_id"].getStr})

proc getLesson*(s: Segment): string = 
  login()
  let now = now().utc#doesnt change
  let res = client.getContent("https://www.classcharts.com/apiv2student/timetable").parseJson["data"]
  for l in res:
    let start = parse(l["start_time"].getStr, "yyyy-MM-dd'T'hh:mm:sszzz")
    if parse(l["start_time"].getStr, "yyyy-MM-dd'T'hh:mm:sszzz") > now:
      let name = LESSON_NAMES[l["subject_name"].getStr]
      s.color = LESSON_COLORS[name]
      return name & " " & l["room_name"].getStr & " " & start.format("hh:mm")