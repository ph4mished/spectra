import strutils, os, terminal, math, sequtils, strformat
import color_helpers

type 
  TempPart* = object
    text*: string
    index*: int #all place holders will be converted to ints
    formatStr*: string

  CompiledTemplate* = object
    parts*: seq[TempPart]
    totalLength*: int

  ColorToggle* = ref object
    enableColor*: bool



# =============================
# PARSE - HELPERS
# =============================
proc parseAlignWidth(input: string): (char, int, bool) =
  #input is already stripped of its placeholder
  if input.len < 2:
    return (char(0), 0, false)
  let align = input[0]
  if align notin ['<', '>']:
    return ('\0', 0, false)
  
  let widthStr = input[1..^1]
  var width: int
  try:
    width = widthStr.parseInt()
  except ValueError, RangeError:
    return ('\0', 0, false)

  if width <= 0:
    return ('\0', 0, false)

  return (align, width, true)



proc buildFormatStr(align: char, width: int): string = 
  case align
  of '<':
    return fmt "%-{width}s"
  of '>':
    return fmt "%{width}s"
  of '^':
    return fmt "%^{width}s"
  else:
    return ""



proc flushText(parts: seq[TempPart], currentText: string): seq[TempPart] =
  result = parts
  if currentText.len > 0:
    result.add(TempPart(text: currentText, index: -1, formatStr: ""))
 



#=============================
# PARSE - PLACEHOLDER
#=============================
#extract placeholders
#placeholders will support padding too. [0:<20] = left alignment, [0:>20] = right align

#========= WHY PADDINGS WERE ADOPTED =========
#crayon added inline padding because doing so with fmt.Printf was cumbersome considering repeated output
#pad := crayon.Parse("[fg=red]Error: [0][reset]")
#using fmt.Printf("%-20s", pad.Sprint("File Not Found"))
#This left aligns the whole "\033[31mError: File Not Found\033[0m" instead of only "File Not Found"

#Although there's a fix, its verbose
# use pad.Println(fmt.Sprintf("%-20s", "File Not Found"))

#So crayon opted for {Define once, pad many times}
# pad := crayon.Parse("[fg=red]Error: [0:<20][reset]")
#  pad.Println("File Not Found") which correctly left aligns only "File Not Found"

#crayon's padding is nothing special, it just does this
#padIt := fmt.Sprintf("%-20s", "File Not Found") in the backend
# pad.Println(padIt)
#Saving you less typing strokes and efficient for repeated outputs
#========= END =========



proc isValidPlaceholder(input: string): bool = 
  input.len > 0 and input.allIt(it in {'0'..'9'})
#eturn len(input) > 0 && allDigits(input)



proc handlePlaceholder(parts: seq[TempPart], contentSequence: string): seq[TempPart] =
  #digit boundary guard to prevent overflow
  let index = contentSequence.parseInt()
  if index in 0..999:
    return @[TempPart(text: "", index: index, formatStr: "")]
  #out of range - treat as literal
  return @[TempPart(text: fmt "[{contentSequence}]", index: -1, formatStr: "")]
  


proc handlePaddedPlaceholder(parts: seq[TempPart], contentSequence: string): seq[TempPart] =
  # [0:>20] stripped of its brackets ==> 0:>20
  let splitWord = contentSequence.split(":", 2) # ==> [0 > 20
  if splitWord.len != 2:
    return @[TempPart(text: fmt "[{contentSequence}]", index: -1, formatStr: "")]
  
  let indexStr = splitWord[0]
  let padStr = splitWord[1]
  let index = indexStr.parseInt()
  if not indexStr.isValidPlaceholder():
    return @[TempPart(text: fmt "[{contentSequence}]", index: -1, formatStr: "")]
  #parse the padStr
  let (align, width, boolean) = parseAlignWidth(padStr)
  if not boolean:
    return @[TempPart(text: fmt "[{contentSequence}]", index: -1, formatStr: "")]
  return @[TempPart(text: "", index: index, formatStr: buildFormatStr(align, width))]




#=============================
# PARSE - SEQUENCE HANDLERS
#=============================

proc isColorSequence(allWords: seq[string]): bool =
  if allWords.len == 0:
    return false
  
  for word in allWords:
    if not word.isSupportedColor():
      return false
  return true



proc handleColorSequence(parts: seq[TempPart], allWords: seq[string], enableColor: bool): seq[TempPart] = 
  result = parts
  if enableColor:
    for word in allWords:
      result.add(TempPart(text: parseColor(word), index: -1, formatStr: ""))
  else:
    result.add(TempPart(text: "", index: -1, formatStr: ""))




proc handleNonColorSequence(parts: seq[TempPart], contentSequence: string): seq[TempPart] = 
  result = parts
  if contentSequence.isValidPlaceholder():
    return parts.handlePlaceholder(contentSequence)
  #For padded placeholders
  if contentSequence.contains(":"):
   return parts.handlePaddedPlaceholder(contentSequence)
  #Unrecognized: pass through as literal
  result.add(TempPart(text: fmt "[{contentSequence}]", index: -1, formatStr: ""))




#=============================
# PARSE - BRACKET HANDLERS
#=============================

proc handleOpenBracket(i: int, input: string, parts: seq[TempPart], currentText: var string): (seq[TempPart], string, string, bool) =
  #Bracket peeling logic - Peel brackets to see if content is a color or not
  #consider first '[' as a text, move until, content is found.
  if i+1 < len(input) and input[i+1] == '[':
    currentText.add("[")
    return (parts, currentText, "", false)
  #flush current text before entering sequence
  let flushedParts = flushText(parts, currentText)
  return (flushedParts, "", "", true)



proc handleCloseBracket(contentSequence: string, parts: seq[TempPart], enableColor: bool): (seq[TempPart], bool) =
  #result = parts
  let allWords = contentSequence.split()
  #or splitWhitespace
  if allWords.isColorSequence():
    result = (parts.handleColorSequence(allWords, enableColor), false)
    #return (newParts, false)
  else:
    result = (parts.handleNonColorSequence(contentSequence), false)
    #return (newParts, false)





#=============================
# PARSE - LOOP
#=============================

#func parseLoop(input string, enableColor bool): ([]TempPart, string) =
proc parseLoop(input: string, enableColor: bool): (seq[TempPart], string) =
  var
    parts: seq[TempPart]
    currentText: string
    contentSequence: string
    inReadSequence: bool


  for i, ch in input:
    let charac = $ch
    

    if charac == "[" and not inReadSequence:
      (parts, currentText, contentSequence, inReadSequence) = handleOpenBracket(i, input, parts, currentText)
    
    elif ch == ']' and inReadSequence:
      (parts, inReadSequence) = handleCloseBracket(contentSequence, parts, enableColor)
      contentSequence = ""
    elif inReadSequence:
      contentSequence.add(charac)
    else:
      currentText.add(charac)

  #Handle unclosed sequence at the end of input
  if inReadSequence and contentSequence.len > 0:
    #Treat unclosed bracket as literal
    parts = flushText(parts, currentText)
    parts.add(TempPart(text: fmt "[{contentSequence}]", index: -1, formatStr: ""))
    currentText = ""
  return (parts, currentText)



#=============================
# APPLY
#=============================
proc apply*(temp: CompiledTemplate, args: varargs[string, `$`]): string {.discardable.}= 
  var allNum: seq[int] = @[]
  for arg in args:
    allNum.add(arg.len)
  
  let estimatedSize = temp.totalLength + sum(allNum)
  result = newStringOfCap(estimatedSize)

  for part in temp.parts:
    if part.index < 0:
      result.add(part.text)
    elif part.index < args.len:
      var value = args[part.index]
      if part.formatStr != "":
        value = part.formatStr % value
      result.add(value)


#==========================================
# PUBLIC API
#==========================================


#=============================
# COLOR TOGGLE
#=============================

proc autoDetect(): bool = 
  return not existsEnv("NO_COLOR") and stdout.isatty()


#should autodetect tty by default 
proc newColorToggle*(enableColor: bool=autoDetect()): ColorToggle = 
  ColorToggle(enableColor: enableColor)


#=============================
# PARSE
#=============================

# Parse template string using the toggle's color setting
proc parse*(toggle: ColorToggle=newColorToggle(), input: string): CompiledTemplate = 
  let (parts, currentText) = parseLoop(input, toggle.enableColor)
  let finalParts = flushText(parts, currentText)
  CompiledTemplate(parts: finalParts, totalLength: input.len)



# Parse template string using auto-detected color support
# User don't need to explicitly define color toggle
proc parse*(input: string): CompiledTemplate =
  return parse(newColorToggle(), input)



#============================
# HELPER FUNCTIONS
#============================

proc `$`*(temp: CompiledTemplate, args: varargs[string, `$`]): string = 
  temp.apply(args)

proc echo*(temp: CompiledTemplate, args: varargs[string, `$`]) =
  stdout.write(temp.apply(args), "\n")

proc write*(temp: CompiledTemplate, f: File, args: varargs[string, `$`]) =
  f.write(temp.apply(args))



