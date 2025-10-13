import strutils, tables, strformat, os
import palette


proc haveTrueColor(): bool = 
  return getEnv("COLORTERM") == "truecolor" 

proc isValidHex(hex: string): bool =
  #hex codes are stripped of their prefix '#' and 'bg=#' before this proc is called
  if hex.len notin [6,8]: #for rrggbb and rrggbbaa
    return false
  for ch in hex:
    if ch notin {'0'..'9', 'a'..'f', 'A'..'F'}:
      return false
  return true


proc isValid256Code(paletteCode: string): bool =
  #codes are stripped of their prefix 'c=' and 'bg=c' before this proc is called
  return parseInt(paletteCode) >= 0 and parseInt(paletteCode) <= 255
    
  


 
#this function was made to validate word in []
proc isSupportedColor(input: string): bool = 
  if input.startsWith("/"):
    return input[1..^1] in colorMap or input[1..^1] in styleMap or input[1..^1] in resetMap or input[1..^1].startsWith("#") and isValidHex(input[2..^1]) or input[1..^1].startsWith("bg=") and isValidHex(input[5..^1])
  #this function is to tell if input is part of the color or style table.
  #this is to tell apart non-tags that are also in square brackets. eg [ERROR] such are sent back as text for coloring if coloring tags surround it
  return input in colorMap or input in styleMap or input in resetMap or input.startsWith("#") and isValidHex(input[1..^1]) or input.startsWith("bg=") and isValidHex(input[4..^1])

proc parseHexToAnsiCode(hex: string): string =
  #passing a hex like "# FF0000" means its for foreground.
  #passing "bg=#FF0000" means its for backgroud
  if hex.len in [7, 10]:
    #for #rrggbb
    if haveTrueColor():
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
        #echo fmt "R: {r}\n G: {g}\n B: {b}\n"
      #foreground colors use 38 and background colors use 48. the 2 is for truecolor support
  #so its \e[38;2;R;G;Bm or for background \e[48;2;R;G;Bm 
  #so the second row of number tells what color mode it is (2: rgb(24 bits), 245)
  # 2 is for truecolor supported numbers that is rgb and its 24 bits using a range of 0-255
  # 5 is for 256 palette(index 196)
  #to avoid contradictions with values like c2020 which stands for copyright or other values that use c for prefix. 
  # 256 palette support synax will be [c=214] = foreground color and [bgc=214] = background color
  # where c = color and bgc = background color

proc parse256ColorCode(paletteCode: string): string =
  if haveTrueColor():
    if paletteCode.startsWith("c="):
      return fmt "\e[38;5;{paletteCode}m"
    elif paletteCode.startsWith("bgc="):
      return fmt "\e[48;5;{paletteCode}m"



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

  #check for valid foreground hex values before parsing
  if color.startsWith("#") and isValidHex(color[1..^1]):
    return parseHexToAnsiCode(color)
  #check for valid background hex values before parsing
  elif color.startsWith("bg") and color[3] == '#':
    return parseHexToAnsiCode(color) 


  #check for valid 256 foreground color palette values before parsing
  if color.startsWith("c=") and isValid256Code(color[2..^1]):
    return parse256ColorCode(color)
  #check for valid background color palette values before parsing
  elif color.startsWith("bgc=") and isValid256Code(color[4..^1]):
    return parse256ColorCode(color)

   
  if color in colorMap:
    return color.replace(color, fmt "\e[{colorMap[color]}m")
  elif color in styleMap:
    return color.replace(color, fmt "\e[{styleMap[color]}m")
  else:
    color.replace(color, fmt "\e[{resetMap[color]}m")




# Global flag for toggling color
#this one will be called when user want color toggling control globally
var colorEnabled*: bool = true

proc paint*(input: string, toStdout=true, colorToggle=colorEnabled): string {.discardable.} =
  var
    content = ""
    output = ""
    currentChar = 0

  while currentChar < input.len:
    if input[currentChar] == '[':
      #start reading
      var nextChar = currentChar + 1
      content = ""

      while nextChar < input.len and input[nextChar] != ']':
        content.add(input[nextChar])
        nextChar.inc()

      if nextChar < input.len:
        let words = content.split(' ')
        #echo "All Words: " & words
        var allColors = true

        for word in words:
          if not isSupportedColor(word):
            #echo "Word: " & word
            allColors = false
            break
        
        if allColors:
          if colorToggle:
            for word in words:
              #echo "Color: " & word
              output.add(parseColor(word))
          currentChar = nextChar + 1  # this is to skip past ']'
          continue
          #else: fall through to literal

      #Not a color or no closing bracket. treat as literal '['
      output.add('[')
      currentChar.inc()
      
    else:
      output.add(input[currentChar])
      currentChar.inc()
    
  if toStdout:
    #echo "Results: " & output
    echo output
  else:
    return output

#"colorToggle" can be used to override "colorEnabled" settings to use its own color toggling

#flaw values like "[red][[green]OPTION][reset]"
#                      "^"
#                      "| look at the arrow" 
#output [green OPTION]
#green doesnt need to be printed as text but due to the previous '[' before its "[green]" tag. it gets counted as text
#[proc paint*(input: string, toStdOut=true, colorToggle = colorEnabled): string {.discardable.} =
  var 
    color = ""
    inReadSequence = false
    output = ""
    word = ""
    #it needs to know next value
    allWords: seq[string] = @[]


  for ch in input:
    #the should be a check if the next char is also an "[". this should run in a loop until no
    #$this parser needs a look ahead before adding "[" as part of color
    if ch == '[' and not inReadSequence:
      inReadSequence = true
      color = ""
      allWords.setLen(0)
      word = ""
    
    elif ch == '[' and inReadSequence:
      inc(ch)
 
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
    elif is
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
  ]#




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


