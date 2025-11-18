import strutils, tables, strformat, os
import palette



proc isValidHex(hexCode: string): bool =
  try:
    if hexCode[4..^1].len notin [6,8]: #for rrggbb and rrggbbaa
      return false
    for ch in hexCode[4..^1]:
      if ch notin {'0'..'9', 'a'..'f', 'A'..'F'}:
        return false
    return true
  except RangeDefect:
    return false


proc isValid256Code(paletteCode: string): bool =
  try:
    return parseInt(paletteCode[3..^1]) >= 0 and parseInt(paletteCode[3..^1]) <= 255
  except Exception:
    return false
    
  
    
  

proc supportsTrueColor(): bool = 
  return getEnv("COLORTERM") == "truecolor"

 
#this function was made to validate words in []
proc isSupportedColor(input: string): bool = 
  return input in paletteMap or input.isValidHex()  or input.isValid256Code() 


proc parseHexToAnsiCode(hex: string): string =

  if hex.len == 10:
    #for #rrggbb
    if supportsTrueColor():
      let r = parseHexInt(hex[4..5])  #this is meant to extract RR
      let g = parseHexInt(hex[6..7])  # this is meant to extract GG
      let b = parseHexInt(hex[8..9])  #to extract BB
      if hex.startsWith("bg="):
        return fmt "\e[48;2;{r};{g};{b}m"
      elif hex.startsWith("fg="):
        return fmt "\e[38;2;{r};{g};{b}m"

#Note:
      #foreground colors use 38 and background colors use 48. the 2 is for truecolor support
  #so its \e[38;2;R;G;Bm or for background \e[48;2;R;G;Bm 
  #so the second row of number tells what color mode it is (2: rgb(24 bits), 245)
  # 2 is for truecolor supported numbers that is rgb and its 24 bits using a range of 0-255
  # 5 is for 256 palette(index 196)
  #to avoid contradictions with values like c2020 which stands for copyright or other values that use c for prefix. 
  # 256 palette support synax will be [c=214] = foreground color and [bg=214] = background color
  # where c = color and bg = background color

proc parse256ColorCode(colorCode: string): string =
  if supportsTrueColor():
    if colorCode.startsWith("bg="):
      return fmt "\e[48;5;{colorCode[3..^1]}m"
    elif colorCode.startsWith("fg="):
      return fmt "\e[38;5;{colorCode[3..^1]}m"


proc parseColor(color: string): string {.discardable.} = 
  #this function is meant to receive string like "bold" "red" and other colors and
  #convert them to their ansi codes
    if color in paletteMap:
      return color.replace(color, fmt "\e[{paletteMap[color]}m")

    elif color.isValid256Code():
      return parse256ColorCode(color)

    elif color.isValidHex():
      return parseHexToAnsiCode(color)
    



# Global flag for toggling color
#this one will be called when user want color toggling control globally
var colorToggle*: bool = true


proc paint*(input: string, toStdout=true, forceColor = colorToggle): string {.discardable.} =
  var 
    color = ""
    inReadSequence = false
    output = ""
    word = ""
    allWords: seq[string] = @[]

  for i, ch in input:
    if ch == '[' and not inReadSequence:
      #check if the next value is "["
      if i + 1 < input.len and input[i+1] == '[':
        output.add('[')
        continue
      else:
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
        try:
          if not isSupportedColor(w):
            allColors = false
        except Exception as e:
          echo e.name, ": ", e.msg
          for trace in e.trace:
            echo "Filename: ", trace.filename
            echo "Procname: ", trace.procname
            echo "Line: ", trace.line, "\n"
          quit(1)

      if allColors:
        for w in allWords:
          if forceColor:
            output.add(parseColor(w))
          else:
            output.add("")
      else:
        output.add("[" & color & "]")
         
        color = ""
    #elif is
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
     
  if toStdout == true:
    echo output
  else:
    return output

