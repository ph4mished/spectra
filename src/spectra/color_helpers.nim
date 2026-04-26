import strutils, strformat, os, tables, sequtils#, winim/lean
import palette



## ==================================================
## To enable ansi color support on windows
## ==================================================
## type "reg add HKCU\Console /v VirtualTerminalLevel /t REG_DWORD /d 1"
## Its color codes are "^[" instead of "\e" and its achieved by click Ctrl+[ on windows 
## remember to import winim/lean



#===========================================
#  WINDOWS SUPPORT
#===========================================

when defined(windows):
  import winlean
  ## This code is from colorizedEcho (https:#github.com/vxcall/colorizeEcho)
  proc setConsoleMode(hConsoleOutput: int, mode: int): int {.stdcall, discardable, dynlib: "kernel32", importc: "SetConsoleMode".}

  proc initColorizeEcho*() {.discardable, init.} =
    const ENABLE_PROCESSED_OUTPUT = 0x0001
    const ENABLE_WRAP_AT_EOL_OUTPUT = 0x0002
    const ENABLE_VIRTUAL_TERMINAL_PROCESSING = 0x0004
    const MODE = ENABLE_PROCESSED_OUTPUT + ENABLE_WRAP_AT_EOL_OUTPUT + ENABLE_VIRTUAL_TERMINAL_PROCESSING
    
    var handle = getStdHandle(-11)
    setConsoleMode(handle, MODE)




#===========================================
#  COLOR DOWNSAMPLING/DEGRADATION
#===========================================

proc rgbTo256Index(r: int, g: int, b: int):int =
  #Find the maximum and minimum channel values
  #to compute the range, spread across RGB channels.
  #A small range means the color is close to neutral/grey.
  var maxC: int = r 
  if g > maxC: 
    maxC = g 
  if b > maxC: 
    maxC = b 

  var minC: int = r 
  if g < minC: 
    minC = g 
  if b < minC: 
    minC = b 
    

  #Used to determine how dark the color is
  var avg: int = (r + g + b ) div 3
    
  #====== GRAYSCALE RAMP ROUTING =========
  #Route to the 24-step grayscale ramp if 
  # - maxC-minC <= 20: The cube is too coarse for neutral tones
  #and introduces visible color casts such as pinkish, greenish, etc.
  #So the threshold was made wide enough (20)
  # - avg > 5:  it allows dark grays to correctly hit the ramp, whiles true or near blacks passes over (0, 0, 8)
  if maxC - minC <= 20 and avg > 5:
    #Clamp avg to the valid grayscale ramp
    #Starts at RGB(8,8,8) and ends at RGB(238,238,238).

    if avg < 8:
      avg = 8
  
    if avg > 238:
      avg = 238
  
  #Tries to map avg to grayscale ramp index 232-255
    return  232 + (avg-8) div 10
  #return  232 + ((avg-8)*23/247)

  #====== COLOR CUBE ROUTING ======
  # for colors where the channel spread exceeds 20.
  var r6: int = (r * 5 + 127) div 255
  var g6: int = (g * 5 + 127) div 255
  var b6: int = (b * 5 + 127) div 255
  #fmt.Printf("RGB TO INDEX FROM COLOR HELPERS CODE (NOT TEST):  RGB=(%d,%d,%d)  | 256 = %d\n", r, g, b, 16 + 36*r6 + 6*g6 +b6)
  return 16 + 36*r6 + 6*g6 + b6



#==================================
# ANSI TERMINAL SUPPORT DETECTION
#==================================
#This only check what the terminal advertises, which isn't always accurate.
#It has to query the terminal directly
#Ways to query the terminal
#echo -e "\e[c"  #What ansi capabilites are supported
#echo -e "\e[>c" # Which terminal emulator you're actually in
proc supportsTrueColor(): bool = 
  return getEnv("COLORTERM") in ["truecolor", "24bit"]

proc supports256Color(): bool =
  let term = getEnv("TERM")
  return term.contains("256color")

proc supportsNone(): bool = 
  let noneTerm = getEnv("TERM")
  return noneTerm == "dumb" or noneTerm.contains("mono")


#===========================================
#  COLOR VALIDATION
#===========================================
#type ExtractedRGB = tuple[seqNum: seq[int], ok: bool]
proc extractRGB(code: string): tuple[values: seq[int], ok: bool] = 
  var seqNum: seq[int]
  let numbers = code[7..^2].split(",")
  if numbers.len == 3:
    for numStr in numbers:
      try:
        seqNum.add(parseInt(numStr))
      except RangeDefect, ValueError:
        return (values: @[], ok: false)
    return (values: seqNum, ok: true)
  return (values: @[], ok: false)



proc hasValidPrefix(inputCode: string): bool =
  return inputCode.startsWith("fg=") or inputCode.startsWith("bg=")


proc hasSpecialPrefix(inputCode: string, prefix: string):bool =
  return (inputCode.startsWith(fmt "fg={prefix}") or inputCode.startsWith(fmt "bg={prefix}"))


proc isValidHex(hexCode: string): bool =
  #fg=#AABBCC
  try:
    #hexCode[4..^1].allIt(it in {'0'..'9', 'a..'f, 'A'..'F'})
    return hexCode[4..^1].len == 6 and allIt(mapIt(hexCode[4..^1], $it), it.allCharsInSet(HexDigits)) and hexCode.hasSpecialPrefix("#")
  except RangeDefect:
    return false



proc isValid256Code(paletteCode: string): tuple[value: int, ok: bool] =
  try:
    let intPalette = parseInt(paletteCode[3..^1])
    return (value: intPalette, ok: intPalette in 0..255 and paletteCode.hasValidPrefix())
  except RangeDefect, ValueError:
    return (value: 0, ok: false)



proc isValidRGB(rgbCode: string): tuple[values: seq[int], ok: bool] =
  #fg=rgb(255,0,0)
  if rgbCode.len in 13..19 and rgbCode[3..6] == "rgb(" and rgbCode[^1] == ')' and rgbCode.hasValidPrefix():
    let res = extractRGB(rgbCode)
    if  res.ok and res.values != @[]: 
      for num in res.values:
        if num notin 0..255:
          return (values: @[], ok: false)
      
      return (values: res.values, ok: true)
    return (values: @[], ok: false)
  return (values: @[], ok: false)


#this function was made to validate words in []
proc isSupportedColor*(input: string): bool = 
  let (_, isValid256) = input.isValid256Code()
  let isValidRGB = input.isValidRGB()
  return input in colorMap or input in resetMap or input in styleMap or input.isValidHex() or isValid256 or isValidRGB.ok



#======================================
# COLOR PARSING
#======================================
proc parseAnsi16(colorCode, ansiAppend: string): string =
  if colorCode.startsWith("bg="):
    let ansiInt = ansiAppend.parseInt() + 10
    return fmt "\e[{ansiInt}m"
  elif colorCode.startsWith("fg="):
    return fmt "\e[{ansiAppend}m"
  return ""



proc parseAnsi(colorCode, ansiAppend: string): string =
  if colorCode.startsWith("bg="):
    return fmt "\e[48;{ansiAppend}m"
  elif colorCode.startsWith("fg="):
    return fmt "\e[38;{ansiAppend}m"

  return ""


proc parseRGBToAnsiCode(rgbCode: string, RGB: seq[int]): string = 
  if supportsTrueColor():
    return parseAnsi(rgbCode, fmt"2;{RGB[0]};{RGB[1]};{RGB[2]}")
  if supports256Color():
    return parseAnsi(rgbCode, fmt "5;{rgbTo256Index(RGB[0], RGB[1], RGB[2])}")
  if not supportsNone():
    return parseAnsi16(rgbCode, $ansi256ToAnsi16Lut[rgbTo256Index(RGB[0], RGB[1], RGB[2])])
  return ""


proc parseHexToAnsiCode(hexCode: string): string =
  let R = parseHexInt(hexCode[4..5])  #this is meant to extract RR
  let G = parseHexInt(hexCode[6..7])  # this is meant to extract GG
  let B = parseHexInt(hexCode[8..9])  #to extract BB
  return parseRGBToAnsiCode(hexCode, @[R, G, B])

    

#Note:
      #foreground colors use 38 and background colors use 48. the 2 is for truecolor support
  #so its \e[38;2;R;G;Bm or for background \e[48;2;R;G;Bm 
  #so the second row of number tells what color mode it is (2: rgb(24 bits), 245)
  # 2 is for truecolor supported numbers that is rgb and its 24 bits using a range of 0-255
  # 5 is for 256 palette(index 196) 
  # 256 palette support synax will be [fg=214] = foreground color and [bg=214] = background color

proc parse256ColorCode(colorCode: string, paletteCode: int): string =
  #256 palette fallback
  if supports256Color():
    return parseAnsi(colorCode, fmt"5;{paletteCode}")
  #ansi 16 fallback
  if not supportsNone():
    return parseAnsi16(colorCode, $ansi256ToAnsi16Lut[paletteCode])
  return ""



#===========================================
#  COLOR DISPATCHING
#===========================================


proc parseColor*(color: string): string {.discardable.} = 
  #this function is meant to receive string like "bold" "fg=red" and other colors and
  #convert them to their ansi codes
  if color in colorMap:
    return fmt "\e[{colorMap[color]}m"

  if color in styleMap:
    return fmt "\e[{styleMap[color]}m"

  if color in resetMap:
    return fmt "\e[{resetMap[color]}m"

  let paletteCode = color.isValid256Code()
  if paletteCode.ok:
    return parse256ColorCode(color, paletteCode.value)

  if color.isValidHex():
    return parseHexToAnsiCode(color)
  
  let rgb = color.isValidRGB()
  if rgb.ok:
    return parseRGBToAnsiCode(color, rgb.values)
  
  return ""
    

