import strutils, tables, strformat, os
import palette


proc haveTrueColor(): bool = 
  return getEnv("COLORTERM") == "truecolor" 

proc isValidHex(hex: string): bool =
  #this function accept hex codes without their '#'
  if hex.len notin [6,8]: #for rrggbb and rrggbbaa
    return false
  for ch in hex:
    if ch notin {'0'..'9', 'a'..'f', 'A'..'F'}:
      return false
  return true


 
#this function was made to tell literals apart
proc isSupportedColor(input: string): bool = 
  if input.startsWith("/"):
    return input[1..^1] in colorMap or input[1..^1] in styleMap or input[1..^1] in resetMap or input[1..^1].startsWith("#") and isValidHex(input[2..^1]) or input[1..^1].startsWith("bg=") and isValidHex(input[5..^1])
  #this function is to tell if input is part of the color or style table.
  #this is to tell apart literals that are also in square brackets. eg [ERROR]
  return input in colorMap or input in styleMap or input in resetMap or input.startsWith("#") and isValidHex(input[1..^1]) or input.startsWith("bg=") and isValidHex(input[4..^1])

proc hexToAnsiCode(hex: string, isBackground: bool): string =
  #passing a hex like "# FF0000" means its for foreground.
  #passing "bg-#FF0000" means its for backgroud
  if haveTrueColor():
    echo hex[5..6]
    let r = parseHexInt(hex[1..2])  #this is meant to extract RR
    let g = parseHexInt(hex[3..4])  # this is meant to extract GG
    let b = parseHexInt(hex[5..6])  #to extract BB
    echo fmt "R: {r}\n G: {g}\n B: {b}\n"
    if isBackground:
      return fmt "\e[48;2;{r};{g};{b}m"
    else:
      return fmt "\e[38;2;{r};{g};{b}m"#foreground colors use 38 and background colors use 48. the 2 is for truecolor support
  #so its \e[38;2;R;G;Bm or for background \e[48;2;R;G;Bm 
  #so the second row of number tells what color mode it is (2: rgb(24 bits), 245)
  # 2 is for truecolor supported numbers that is rgb and its 24 bits using a range of 0-255
  # 5 is for 256 palette(index 196)


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
    elif color.startsWith("/#") and isValidHex(color[2..^1]):
      let fgRstMap = resetMap["fgReset"]
      return fmt "\e[{fgRstMap}m"

      #for styles
    elif color[1..^1] in styleMap:
      let styMp = styleMap[fmt "reset{color[1..^1].capitalizeAscii()}"]
      return fmt "\e[{styMp}m"
    #[else:
      let rstMap = resetMap["reset"]
      return fmt "\e[{rstMap}m"]#
    #else:
      #return ""

  if color.startsWith("#") and isValidHex(color[1..^1]):
    #check for foreground hex
    return hexToAnsiCode(color, false)
  elif color.startsWith("bg") and color[3] == '#':
    return hexToAnsiCode(color[3..^1], true) 

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

paint "[#FF0000] Hi [/#FF0000]"
paint "[bg=#FF0000] Shit [/bg=#FF0000]"

paint "[lightYellow][bold underline]THICC TEXT [/underline /bold] [regular]REGULAR TEXT[reset]"
let me = paint("[red][ERROR][reset]", false)]#
#echo me
#echo me
#discard me


