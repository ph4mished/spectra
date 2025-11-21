import strutils, tables, strformat, os
import color_helpers

## This code is an inspiration/copy of https://github.com/Kashiwara0205/monkey-nim/blob/master/src/lexer/lexer.nim which is a nim implementation of the monkey language
#type 
  #Lexer* = object
    #input*: string
    #position*: int
    #readPosition*: int
    #ch*: byte
#spectra direct coloring is to expensive for loops and inefficient for performance.
#a proc will be added to compile first hand before looping.
## eg.
## let test = compile("[bold fg=red]Sorry I'm Red [reset]")
## for i in 0..10000000:
##   echo test.apply()


type 
  TempPart* = object
    text*: string #tags and others are assumed strings
    index*: int #all place holders will be converted to ints

  CompiledTemplate* = object
    parts*: seq[TempPart]
# Global flag for toggling color
#this one will be called when user want color toggling control globally
var colorToggle*: bool = true

#[proc readNumber(tag: string): string = 
  while tag.isDigit():
    readChar()

proc readString(tag: string): string =
  while tag.is]#

proc compile(input: string): CompiledTemplate =
  var 
    contentSequence = ""
    inReadSequence = false
    parts: seq[TempPart] = @[]
    currentText = ""
    word = ""
    allWords: seq[string] = @[]

  for i, ch in input:
    if ch == '[' and not inReadSequence:
      #check if the next value is "["
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
      
      #check if content is a placeholder or tag
      #if contentSequence.len == 1 and contentSequence in {'0'..'9'}:
        #parts.add(TempPart(text: "", placeholder: parseInt(contentSequence)))
      #else:
    #if last word is present, add it
      allWords = contentSequence.splitWhiteSpace()

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
          parts.add(TempPart(text: parseColor(w), index: -1))
        
      else:
        if parseInt(contentSequence) in {0..9}:
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
  
  result = CompiledTemplate(parts: parts)


proc apply*(temp: CompiledTemplate, args: varargs[string]): string = 
  for part in temp.parts:
    if part.index < 0:
      result.add(part.text)
    else:
      if part.index < args.len:
        result.add(args[part.index])




#[proc paint*(input: string, toStdout=true, forceColor = colorToggle): string {.discardable.} =
  if toStdout:
    echo compile(input)
  else:
    return (input)]#
  

when isMainModule:
  import times
  let startTime = cpuTime()
  let filename = "example.txt"
  let comp = compile("[bold fg=cyan italic] Processing [0] [fg=yellow underline fg=green strike]from [dim blinkfast   fg=#FFFFFF] file [1] [reverse fg=254]to end[reset]")


  for i in 0..1000000:
    #echo "Compiled: ", comp.apply($i, filename)
    discard comp.apply($i)
  let endTime = cpuTime()


  #Checking without spectra
  let nStartTime = cpuTime()
  for i in 0..1000000:
    discard fmt "Processing {i} from file 1  to end."
  let nEndTime = cpuTime()


  echo "First Loop Duration [With Compiled Spectra]: ", nEndTime-nStartTime, "sec"
  echo "Last Loop Duration [Without Spectra]: ", nEndTime-nStartTime, "sec"