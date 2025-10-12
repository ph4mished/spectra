import strutils, tables, strformat
import palette


 
 
#this function was made to tell literals apart
proc isPartOfTable(input: string): bool = 
  if input.startsWith("/"):
    return input[1..^1] in colorMap or input[1..^1] in styleMap or input[1..^1] in resetMap
  #this function is to tell if input is part of the color or style table.
  #this is to tell apart literals that are also in square brackets. eg [ERROR]
  return input in colorMap or input in styleMap or input in resetMap

proc parseColor(color: string): string {.discardable.} = 
  #this function is meant to receive string like "bold" "red" and other colors and
  #convert them to their ansi codes
  #for strings with /
  if color.startsWith('/'):
    if color[1..2] == "bg":
      let bgRstMap = resetMap["bgReset"]
      return fmt "\e[{bgRstMap}m"
    elif color[1..^1] in colorMap:
      let fgRstMap = resetMap["fgReset"]
      return fmt "\e[{fgRstMap}m"
      #for styles
    elif color[1..^1] in styleMap:
      let styMp = styleMap[fmt "reset{color[1..^1].capitalizeAscii()}"]
      #echo styMp
      return fmt "\e[{styMp}m"
    #[else:
      let rstMap = resetMap["reset"]
      return fmt "\e[{rstMap}m"]#
    #else:
      #return ""

  if color in colorMap:
    return color.replace(color, fmt "\e[{colorMap[color]}m")
  elif color in styleMap:
    return color.replace(color, fmt "\e[{styleMap[color]}m")
  else:
    color.replace(color, fmt "\e[{resetMap[color]}m")


#parseHex(hexStr: string): string =
  #this one receives hex strings and get parsed to their ansi codes


#parseRGB()

# Global flag for tsoggling color
var colorEnabled*: bool = true

proc paint*(input: string, toStdOut=true, colorToggle = colorEnabled): string {.discardable.} =
  var 
    color = ""
    inReadSequence = false
    output = ""
    word = ""
    allWords: seq[string] = @[]


  for ch in input:
    if ch == '[' and not inReadSequence:
      inReadSequence = true
      color = ""
      allWords.setLen(0)
      word = ""
 
    elif ch == ']' and inReadSequence:
      inReadSequence = false

    #if last word is present, add it
      if word.len > 0:
        allWords.add(word)
        word = ""

        #check if all words are colors
      var allColors = allWords.len > 0
      for w in allWords:
        if not isPartOfTable(w):
          allColors = false
          break

      if allColors:
        for w in allWords:
          output.add(parseColor(w))
      else:
        output.add("[" & color & "]")
         
        color = ""
    elif inReadSequence:
      color.add(ch)

      if ch == ' ':
        if word.len > 0:
          allWords.add(word)
          word = ""
      else:
        word.add(ch)

    else:
      output.add(ch)
     
  if toStdOut == true:
    echo output
  else:
    return output






paint ("[blue bold] Hi [reset]")
let me = paint("[red][ERROR][reset]", false)
#echo me
#echo me
discard me


