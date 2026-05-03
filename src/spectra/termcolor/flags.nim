import strutils, unicode, sequtils

var
  colorPosArgs* = @["on", "true", "yes", "1", "always", "force"]
  colorNegArgs* = @["off", "false", "no", "0", "never", "none"]
  colorAutoArgs* = @["auto", "tty", "detect"]


proc matchNextArg(arg: string, seqArgs: seq[string]): bool = 
  for value in seqArgs:
    if arg == value:
      return true
  return false


proc getNextArg(cachedArgs: seq[string], flag: string, delimiter: string): (string, bool) =
  let flagDelim = flag & delimiter
  let args = cachedArgs

  for i, arg in args:
    var cleanArg = arg.strip(leading=true, trailing=false, chars={'-'})
    
    #GNU Style
    if cleanArg.startsWith(flagDelim):
      return (cleanArg.strip(leading=false).subStr(flagDelim.len), true)

    # POSIX Style
    if cleanArg == flag:
      if i + 1 < args.len:
        let nextArg = args[i+1]
        #Check if next arg is not a flag or is not a negative number or just a hyphen
        if not nextArg.startsWith("-") or nextArg[1..^1].allIt(it in {'0'..'9'}) or nextArg == "-":
          return (nextArg, true)

      #Flag has no value (boolean)
      return ("", true)
  #Flag not present
  return ("", false)


proc checkColorToggle*(cachedArgs: seq[string], flag: string, delimiter: string, seqArgs: seq[string]): bool =
  let (nextArg, boolean) = getNextArg(cachedArgs, flag, delimiter)
  if boolean:
    if nextArg != "":
      return matchNextArg(nextArg, seqArgs)
    return true
  return false








