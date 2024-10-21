import osproc
import ../segment

proc getKeyboard*(s: Segment): string = 
  execProcess("setxkbmap -query | awk 'NR==3 {print $2}'")




  
