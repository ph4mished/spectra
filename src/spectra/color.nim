import strutils, tables, strformat, os
import palette



proc isValidHex(hex: string): bool =
  #hex codes are stripped of their prefix '#' and 'bg=#' before this proc is called
  if hex.len notin [6,8]: #for rrggbb and rrggbbaa
    return false
  for ch in hex:
    if ch notin {'0'..'9', 'a'..'f', 'A'..'F'}:
      return false
  return true


proc isValid256Code(paletteCode: string): bool =
  #codes are stripped of their prefix 'c=' and 'bg=' before this proc is called
  return parseInt(paletteCode) >= 0 and parseInt(paletteCode) <= 255
    
  

proc supportsTrueColor(): bool = 
  return getEnv("COLORTERM") == "truecolor"
 
#this function was made to validate words in []
proc isSupportedColor(input: string): bool = 
  if input.startsWith("/"):
    return input[1..^1] in colorMap or input[1..^1] in styleMap or input[1..^1] in resetMap or input[1..^1].startsWith("#") and isValidHex(input[2..^1]) or input[1..^1].startsWith("bg=") and isValidHex(input[5..^1]) or input[1..^1].startsWith("bg=") and isValid256Code(input[4..^1]) or input[1..^1].startsWith("c=") and isValid256Code(input[3..^1])
  #this function is to tell if input enclosed in [] is part of the color or style table.
  #this is to tell apart non-tags that are also in square brackets. eg [ERROR] such are sent back as text for coloring.
  return input in colorMap or input in styleMap or input in resetMap or input.startsWith("#") and isValidHex(input[1..^1]) or input.startsWith("bg=") and isValidHex(input[4..^1]) or input.startsWith("bg=") and isValid256Code(input[3..^1]) or input.startsWith("c=") and isValid256Code(input[2..^1])

proc parseHexToAnsiCode(hex: string): string =
  #passing a hex like "#FF0000" means its for foreground.
  #passing "bg=#FF0000" means its for backgroud
  if hex.len in [7, 10]:
    #for #rrggbb
    if supportsTrueColor():
      if hex.startsWith("bg="):
        let r = parseHexInt(hex[4..5])  #this is meant to extract RR
        let g = parseHexInt(hex[6..7])  # this is meant to extract GG
        let b = parseHexInt(hex[8..9])  #to extract BB
        return fmt "\e[48;2;{r};{g};{b}m"
      else:
        let r = parseHexInt(hex[1..2])  #this is meant to extract RR
        let g = parseHexInt(hex[3..4])  # this is meant to extract GG
        let b = parseHexInt(hex[5..6])  #to extract BB
        return fmt "\e[38;2;{r};{g};{b}m"
      #foreground colors use 38 and background colors use 48. the 2 is for truecolor support
  #so its \e[38;2;R;G;Bm or for background \e[48;2;R;G;Bm 
  #so the second row of number tells what color mode it is (2: rgb(24 bits), 245)
  # 2 is for truecolor supported numbers that is rgb and its 24 bits using a range of 0-255
  # 5 is for 256 palette(index 196)
  #to avoid contradictions with values like c2020 which stands for copyright or other values that use c for prefix. 
  # 256 palette support synax will be [c=214] = foreground color and [bg=214] = background color
  # where c = color and bg = background color

proc parse256ColorCode(paletteCode: string): string =
  if supportsTrueColor():
    if paletteCode.startsWith("c="):
      return fmt "\e[38;5;{paletteCode[2..^1]}m"
    elif paletteCode.startsWith("bg="):
      return fmt "\e[48;5;{paletteCode[4..^1]}m"



proc parseColor(color: string): string {.discardable.} = 
  #this function is meant to receive string like "bold" "red" and other colors and
  #convert them to their ansi codes
  #for strings with /
  if color.startsWith('/'):
    #all values with /bg are handled here /bg=#FF0000 or /bgRed or /bg=45
    if color[1..2] == "bg":
      let bgRstMap = resetMap["bgReset"]
      return fmt "\e[{bgRstMap}m"

    elif color[1..^1] in colorMap:
      let fgRstMap = resetMap["fgReset"]
      return fmt "\e[{fgRstMap}m"

    elif color.startsWith("/#") and isValidHex(color[2..^1]) or color.startsWith("/c=") and isValid256Code(color[3..^1]):
      let fgRstMap = resetMap["fgReset"]
      return fmt "\e[{fgRstMap}m"

      #for styles
    elif color[1..^1] in styleMap:
      let styMp = styleMap[fmt "reset{color[1..^1].capitalizeAscii()}"]
      return fmt "\e[{styMp}m"

  #check for valid foreground hex values before parsing
  if color.startsWith("#") and isValidHex(color[1..^1]):
    return parseHexToAnsiCode(color)
  #check for valid background values before parsing
  elif color.startsWith("bg="):
    if color[3] == '#' and isValidHex(color[4..^1]):
      return parseHexToAnsiCode(color) 
    elif isValid256Code(color[3..^1]):
      return parse256ColorCode(color)


  #check for valid 256 foreground color palette values before parsing
  #echo "Stripped color: " & color[2..^1]
  if color.startsWith("c=") and isValid256Code(color[2..^1]):
    return parse256ColorCode(color)
  #check for valid background color palette values before parsing
  #elif color.startsWith("bg=") and isValid256Code(color[4..^1]):
   # return parse256ColorCode(color)

   
  if color in colorMap:
    return color.replace(color, fmt "\e[{colorMap[color]}m")
  elif color in styleMap:
    return color.replace(color, fmt "\e[{styleMap[color]}m")
  else:
    color.replace(color, fmt "\e[{resetMap[color]}m")




# Global flag for toggling color
#this one will be called when user want color toggling control globally
var colorEnabled*: bool = true


proc paint*(input: string, toStdOut=true, colorToggle = colorEnabled): string {.discardable.} =
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
        if not isSupportedColor(w):
          allColors = false
          break

      if allColors:
        for w in allWords:
          if colorToggle:
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
     
  if toStdOut == true:
    echo output
  else:
    return output




#colorEnabled = true
#trying to use an alias
#[let be = "blue"
paint fmt "[{be} bold] Hi [reset]"
paint "[bold magenta]Every [ /bold green]color [cyan]is [default]beautiful.[reset]"

paint "[black][bgMagenta]Background [bgGreen]color [bgLightRed]is [bgCyan]changable [bgYellow]too.[bgReset]"

paint "[bold red][[blue]OPTION[/blue red]][reset]"

paint "[#FF0000] Hi [/#FF0000]"
paint "[bg=#FF0000] Shit [/bg=#FF0000]"

paint "[c=255 bg=236] Hi [reset]"
paint "[c=255 bg=236] Shit [reset]"

paint "[lightYellow][bold underline]THICC TEXT [/underline /bold] [regular]REGULAR TEXT[reset]"
let me = paint("[red][ERROR][reset]", false)
#echo me
#echo me
discard me]#


