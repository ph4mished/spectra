import strutils, strformat, os, tables#, winim/lean
import palette
  
#rgb and hsl will be added
#as in rgb with percentages vs rgb with actual numbers

## ==================================================
## To enable ansi color support on windows
## ==================================================
## type "reg add HKCU\Console /v VirtualTerminalLevel /t REG_DWORD /d 1"
## Its color codes are "^[" instead of "\e" and its achieved by click Ctrl+[ on windows 
## remember to import winim/lean

## This code is from colorizedEcho (https://github.com/vxcall/colorizeEcho)
#[proc setConsoleMode(hConsoleOutput: int, mode: int): int {.stdcall, discardable, dynlib: "kernel32", importc: "SetConsoleMode".}

proc initColorizeEcho*() {.discardable.} =
    const ENABLE_PROCESSED_OUTPUT = 0x0001
    const ENABLE_WRAP_AT_EOL_OUTPUT = 0x0002
    const ENABLE_VIRTUAL_TERMINAL_PROCESSING = 0x0004
    const MODE = ENABLE_PROCESSED_OUTPUT + ENABLE_WRAP_AT_EOL_OUTPUT + ENABLE_VIRTUAL_TERMINAL_PROCESSING
    
    var handle = getStdHandle(-11)
    setConsoleMode(handle, MODE)]#

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
    return parseInt(paletteCode[3..^1]) in 0..255
  except RangeDefect, ValueError:
    return false
    
  
    
  

proc supportsTrueColor(): bool = 
  return getEnv("COLORTERM") == "truecolor"

 
#this function was made to validate words in []
proc isSupportedColor*(input: string): bool = 
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
  # 256 palette support synax will be [fg=214] = foreground color and [bg=214] = background color

proc parse256ColorCode(colorCode: string): string =
 
  if colorCode.startsWith("bg="):
    return fmt "\e[48;5;{colorCode[3..^1]}m"
  elif colorCode.startsWith("fg="):
    return fmt "\e[38;5;{colorCode[3..^1]}m"


proc parseColor*(color: string): string {.discardable.} = 
  #this function is meant to receive string like "bold" "fg=red" and other colors and
  #convert them to their ansi codes
  if color in paletteMap:
    return color.replace(color, fmt "\e[{paletteMap[color]}m")

  elif color.isValid256Code():
    return parse256ColorCode(color)

  elif color.isValidHex():
    return parseHexToAnsiCode(color)
    
