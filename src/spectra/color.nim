import strutils, os, terminal
import color_helpers

## This code is an inspiration/copy of https://github.com/Kashiwara0205/monkey-nim/blob/master/src/lexer/lexer.nim which is a nim implementation of the monkey language
#type 
  #Lexer* = object
    #input*: string
    #position*: int
    #readPosition*: int
    #ch*: byte

type 
  TempPart* = object
    text*: string 
    index*: int #all place holders will be converted to ints

  CompiledTemplate* = object
    parts*: seq[TempPart]

  ColorToggle* = ref object
    enableColor*: bool


proc autoDetect(): bool = 
  return not existsEnv("NO_COLOR") and stdout.isatty()


#should autodetect tty by default 
proc newColorToggle*(enableColor: bool=autoDetect()): ColorToggle = 
  ColorToggle(enableColor: enableColor)

proc compile*(toggle: ColorToggle=newColorToggle(), input: string): CompiledTemplate =
  var 
    contentSequence = ""
    inReadSequence = false
    parts: seq[TempPart] = @[]
    currentText = ""
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
          #needs proper error handling
          echo e.name, ": ", e.msg
          for trace in e.trace:
            echo "Filename: ", trace.filename
            echo "Procname: ", trace.procname
            echo "Line: ", trace.line, "\n"
          quit(1)

      if allColors:
        if toggle.enableColor:
          for w in allWords:
            parts.add(TempPart(text: parseColor(w), index: -1))
        else:
          parts.add(TempPart(text: "", index: -1))
        
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
  #echo result

#Override
proc compile*(input: string): CompiledTemplate =
  return compile(newColorToggle(), input)

proc apply*(temp: CompiledTemplate, args: varargs[string]): string {.discardable.}= 
  for part in temp.parts:
    if part.index < 0:
      result.add(part.text)
    else:
      if part.index < args.len:
        result.add(args[part.index])




#proc paint*(input: string, toStdout=true, forceColor = colorToggle): string {.discardable.} =
  #if toStdout:
    #echo compile(input).apply()
  #else:
    #return compile(input).apply()
  

#[when isMainModule:
  import times
  #let user = newColorToggle()
  let help_temp = compile("[bold fg=cyan][0][fg=green], [fg=cyan][1][bold=reset fg=green]: [fg=yellow][2][reset]")

  echo help_temp.apply("-h", "--help", "Show help and exit")
  echo help_temp.apply("-v", "--version", "Show version")
  echo help_temp.apply("-r", "--recursive", "Run recursively")

  let itemTemp = compile("[0], [fg=cyan][1][reset]")

  let fruits = @["Apple", "Watermelon", "Grapes", "Banana"]
  for i, fruit in fruits:
    echo itemTemp.apply($(i+1), fruit)

  let temp_template = compile("Temperature: [0]")

  proc showTemp(temp: int) =
    let color = if temp > 25: "[fg=red]" elif temp < 10: "[fg=blue]" else: "[fg=green]"
    let comp = compile(color & "[0]°C[reset]")
    echo temp_template.apply(comp.apply($temp))

  showTemp(25)
  showTemp(14)
  showTemp(4)

  let loginTemp = compile("""
  Username: [fg=cyan][0][reset]
  Password: [fg=yellow][1][reset]
  """)

  echo loginTemp.apply("Jay Pal", "********")

  echo compile("""
  [fg=#FF0000][0][fg=#FF3300][0][fg=#FF6600][0][fg=#FF9900][0][fg=#FFCC00][0][reset]
  [fg=#CC0000][0][fg=#CC3300][0][fg=#CC6600][0][fg=#CC9900][0][fg=#CCCC00][0][reset]
  [fg=#990000][0][fg=#993300][0][fg=#996600][0][fg=#999900][0][fg=#99CC00][0][reset]
  """).apply("▓▓▓")

  let blkTemp = compile("[fg=red][0][fg=green][0][fg=blue][0][reset]")
  let lastTemp = compile("[fg=yellow][0][fg=magenta][0][fg=cyan][0][reset]\n")

  echo blkTemp.apply("████████")
  echo blkTemp.apply("████████")
  echo lastTemp.apply("████████")


  let btnTemplate  = compile("[fg=255 bg=24][0][reset]")
  echo btnTemplate.apply("┌────────────────────┐")
  echo btnTemplate.apply("│       Submit       │")
  echo btnTemplate.apply("└────────────────────┘")

  echo compile("[fg=green bold]Hey Fred, be [0] and [1] hard[reset]").apply("[bold]", "[strike]")]##Safe for escapes too

  #echo user.compile("[bold fg=yellow][0] [fg=red strike] world[reset]").apply("hello")
  #[let startTime = cpuTime()
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
  echo "Last Loop Duration [Without Spectra]: ", nEndTime-nStartTime, "sec"]#