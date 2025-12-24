import strutils, os, terminal, math, sequtils, tables, strformat
import color_helpers, palette

type 
  TempPart* = object
    text*: string
    index*: int #all place holders will be converted to ints

  CompiledTemplate* = object
    parts*: seq[TempPart]
    totalLength*: int

  ColorToggle* = ref object
    enableColor*: bool



proc autoDetect(): bool = 
  return not existsEnv("NO_COLOR") and stdout.isatty()


#should autodetect tty by default 
proc newColorToggle*(enableColor: bool=autoDetect()): ColorToggle = 
  ColorToggle(enableColor: enableColor)

proc parse*(toggle: ColorToggle=newColorToggle(), input: string): CompiledTemplate =
  var 
    contentSequence = ""
    inReadSequence = false
    parts: seq[TempPart] = @[]
    currentText = ""
    allWords: seq[string] = @[]

  for i, ch in input:
    if ch == '[' and not inReadSequence:
      #check if the next value is "["
      # [[fg=color]] should never be an escape
      #consider first '[' as a text, move until, you content. 
      if i + 1 < input.len and input[i+1] == '[':
        currentText.add('[')
        continue
      else:
        inReadSequence = true
        contentSequence = ""
        allWords.setLen(0)

        if currentText.len > 0:
          parts.add(TempPart(text: currentText, index: -1))
          currentText = ""
 
    elif ch == ']' and inReadSequence:
      inReadSequence = false
      
    #if last word is present, add it
      allWords = contentSequence.splitWhiteSpace()

        #check if all words are colors
      var allColors = allWords.len > 0
      for w in allWords:
        try:
          if not isSupportedColor(w):
            allColors = false
        except Exception as e:
          #needs proper error handling
          echo e.name, ": ", e.msg
          for trace in e.trace:
            echo "Filename: ", trace.filename
            echo "Procname: ", trace.procname
            echo "Line: ", trace.line, "\n"
          echo "\e[1;32m[NOTE] \e[33mThis is definitely a bug in spectra internal system.\nPlease report as an issue at \e[34mhttps://github.com/ph4mished/spectra/issues\e[0m"
          quit(1)

      if allColors:
        if toggle.enableColor:
          for w in allWords:
            parts.add(TempPart(text: parseColor(w), index: -1))
        else:
          parts.add(TempPart(text: "", index: -1))
        
      else:
        if contentSequence.len > 0 and  all(contentSequence, isDigit):
          #decided to make it flexible and accept more indices but its still prone to overflow
          #needs a digit boundary guard
          parts.add(TempPart(text: "", index: parseInt(contentSequence)))
        else:
          let addText = "[" & contentSequence & "]"
          parts.add(TempPart(text: addText, index: -1))
  
    elif inReadSequence:
      contentSequence.add(ch)

    else:
      currentText.add(ch)
  
  if currentText.len > 0:
    parts.add(TempPart(text: currentText, index: -1))
  
  result = CompiledTemplate(parts: parts, totalLength: input.len)
  
#Override
proc parse*(input: string): CompiledTemplate =
  return parse(newColorToggle(), input)


proc apply*(temp: CompiledTemplate, args: varargs[string]): string {.discardable.}= 

  var allNum: seq[int] = @[]
  for arg in args:
    allNum.add(arg.len)
  
  let estimatedSize = temp.totalLength + sum(allNum)
  result = newStringOfCap(estimatedSize)

  for part in temp.parts:
    if part.index < 0:
      result.add(part.text)
    else:
      if part.index < args.len:
        result.add(args[part.index])



# A  convenience function to list supported colors
#proper formatting is on the way
proc listColors*() =
  for key, val in colorMap.pairs:
    echo fmt "Color: {key}  | \e[{val}m▒▒▒▒▒▒▒\e[0m\n"


#[proc listResets*() =
  for key, val in resetMap.pairs:
    echo fmt "Style: {key}  | \e[{val}mHello World\e[0m\n"
]#
    
proc listStyles*() =
  for key, val in styleMap.pairs:
    echo fmt "Style: {key}  | \e[{val}mHello World\e[0m\n"



