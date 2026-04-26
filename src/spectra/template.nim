import strutils, os, terminal, math, sequtils, unicode
import color_helpers

type 
  TempPart* = object
    text*: string
    index*: int #all place holders will be converted to ints
    formatStr*: string




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
    
#		switch {
    case
    of charac == "[" and not inReadSequence:
      (parts, currentText, contentSequence, inReadSequence) = handleOpenBracket(i, input, parts, currentText)
    
    of ch == ']' and inReadSequence:
      (parts, inReadSequence) = handleCloseBracket(contentSequence, parts, enableColor)
      contentSequence = ""
    of inReadSequence:
      contentSequence.add(charac)
    else:
      currentText.add(charac)

  #Handle unclosed sequence at the end of input
  if inReadSequence and contentSequence.len > 0:
    #Treat unclosed bracket as literal
    parts = flushText(parts, currentText)
    parts.add(TempPart(text: "[" + contentSequence, index: -1, formatStr: ""))
    currentText = ""
  return parts, currentText



#=============================
# PARSE - BRACKET HANDLERS
#=============================

#func handleOpenBracket(i int, input string, parts []TempPart, currentText string) ([]TempPart, string, string, bool) {
proc handleOpenBracket(i: int, input: string, parts: seq[TempPart], currentText: string): (seq[TempPart], string, string, bool) =
  #Bracket peeling logic - Peel brackets to see if content is a color or not
  #consider first '[' as a text, move until, content is found.
  if i+1 < len(input) && input[i+1] == '[':
    currentText += "["
    return (parts, currentText, "", false)
  #flush current text before entering sequence
  parts = flushText(parts, currentText)
  return (parts, "", "", true)


#func handleCloseBracket(contentSequence string, parts []TempPart, enableColor bool) ([]TempPart, bool) {
proc handleCloseBracket(contentSequence: string, parts: seq[TempPart], enableColor: bool): (seq[TempPart], bool) =
  let allWords = contentSequence.split()
  #or splitWhitespace
  if allWords.isColorSequence():
    parts = handleColorSequence(parts, allWords, enableColor)
  else:
    parts = handleNonColorSequence(parts, contentSequence)
  return parts, false



#=============================
# PARSE - SEQUENCE HANDLERS
#=============================

#func isColorSequence(words []string) bool {
proc isColorSequence(allWords: seq[string]): bool =
  if allWords.len == 0:
    return false
  
  for word in allWords:
    if not word.isSupportedColor():
      return false
  return true


#func handleColorSequence(parts []TempPart, words []string, enableColor bool) []TempPart {
proc handleColorSequence(parts: seq[TempPart], allWords: seq[string], enableColor: bool): seq[TempPart] = 
  if enableColor:
    for word in allWords:
      parts.add(TemPart(text: parseColor(word), index: -1, formatStr: ""))
  else:
    parts.add(TempPart(text: "", index: -1, formatStr: ""))
  return parts


#func handleNonColorSequence(parts []TempPart, contentSequence string) []TempPart {
proc handleNonColorSequence(parts: seq[TempPart], contentSequence: string): seq[TempPart] = 
  if contentSequence.isValidPlaceholder():
    return parts.handlePlaceholder(contentSequence)
  #For padded placeholders
  if contentSequence.contains(":"):
    return parts.handlePaddedPlaceholder(contentSequence)
  #Unrecognized: pass through as literal
  return parts.add(TempPart(text: fmt "[{contentSequence}]", index: -1, formatStr: ""))


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


#func isValidPlaceholder(input string) bool {
proc isValidPlaceholder(input: string): bool = 
  return input.len > 0 and allIt(mapIt(input, $it), it.allCharsInSet(Digits))
	#eturn len(input) > 0 && allDigits(input)


#func handlePlaceholder(parts []TempPart, contentSequence string) []TempPart {
proc handlePlaceholder(parts: seq[TempPart, contentSequence: string]): seq[TempPart] =
  #digit boundary guard to prevent overflow
  let index = contentSequence.parseInt()
  if index in 0..999:
    return parts.add(TempPart(text: "", index: index, formatStr: ""))
  #out of range - treat as literal
  return parts.add(TempPart(text: fmt "[{contentSequence}]", index: -1, formatStr: ""))
  

#func handlePaddedPlaceholder(parts []TempPart, contentSequence string) []TempPart {
proc handlePaddedPlaceholder(parts: seq[TempPart], contentSequence: string): seq[TempPart] =
  # [0:>20] stripped of its brackets ==> 0:>20
  let splitWord = contentSequence.split(contentSequence, ":", 2) # ==> [0 > 20
  if splitWord.len != 2:
    return parts.add(TempPart(text: fmt "[{contentSequence}]", index: -1, formatStr: ""))
  
  let indexStr = splitWord[0]
  let padStr = splitWord[1]
  let index = indexStr.parseInt()
  if not index.isValidPlaceholder():
    return parts.add(TempPart(text: fmt "[{contentSequence}]", index: -1, formatStr: ""))
  #parse the padStr
  let (align, width, boolean) = parseAlignWidth(padStr)
  if not boolean:
    return parts.add(TempPart(text: fmt "[{contentSequence}]", index: -1, formatStr: "")) 
  return parts.add(TempPart(text: "", index: index, formatStr: buildFormatStr(align, width)))


# =============================
# PARSE - HELPERS
# =============================
#func parseAlignWidth(input string) (rune, int, bool) {
proc parseAlignWidth(input: string): (Rune, int, bool) =
  #input is already stripped of its placeholder
  if input.len < 2:
    return 0, 0, false
  let align = toRune(input[0])
  if align != '<' and align != '>':
    return 0, 0, false
  
  let widthStr = input[1..^1]
  try:
    let width = widthStr.parseInt()
    if width <= 0:
      return 0, 0, false
  except ValueError, RangeError:
    return 0, 0, 0
  return  align, width, true


#func buildFormatStr(align rune, width int) string {
proc buildFormatStr(align: char, width: int): string = 
  case align
  of '<':
    return fmt "%-{width}s"
  of '>':
    return fmt "%{width}s"
  of '^':
    return fmt "%^{width}s"
  return ""


#func flushText(parts []TempPart, currentText string) []TempPart {
proc flushText(parts: seq[TempPart], currentText: string): seq[TempPart] =
  if currentText.len > 0:
    parts.add(TempPart(text: currentText, index: -1, formatStr: ""))
  return parts


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
      #result.add(args[part.index])
      
    #else:
     # if part.index < args.len:
      #  result.add(args[part.index])



	#[for _, part := range temp.Parts {
		if part.Index < 0 {
			result.WriteString(part.Text)
		} else if part.Index < len(args) {
			value := fmt.Sprint(args[part.Index])
			if part.FormatStr != "" {				
				value = fmt.Sprintf(part.FormatStr, value)
			}
			result.WriteString(value)
		}
	}
	return result.String()
}]#

# =======================
# PRINT
# =======================
func (temp CompiledTemplate) Println(args ...any) {
	fmt.Println(temp.apply(args...))
}

func (temp CompiledTemplate) Print(args ...any) {
	fmt.Print(temp.apply(args...))
}

# =======================
# FPRINT
# =======================
func (temp CompiledTemplate) Fprintln(w io.Writer, args ...any) (n int, err error) {
	return fmt.Fprintln(w, temp.apply(args...))
}

func (temp CompiledTemplate) Fprint(w io.Writer, args ...any) (n int, err error) {
	return fmt.Fprint(w, temp.apply(args...))
}

# =======================
# SPRINT
# =======================
func (temp CompiledTemplate) Sprintln(args ...any) string {
	return fmt.Sprintln(temp.apply(args...))
}

func (temp CompiledTemplate) Sprint(args ...any) string {
	return temp.apply(args...)
}
