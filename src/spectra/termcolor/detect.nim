import os, osproc, strutils, terminal


type  ColorCap* = int

const
  Unknown: ColorCap = -1
  ColorNone*: ColorCap = 0
  Color16*: ColorCap = 16
  Color256*: ColorCap = 256
  ColorTrue*: ColorCap = 16777216


#=======================================
# MINI TERMINAL LEVEL SUPPORTS CHECKS
#=======================================

proc supportsTrueColor(colorTerm: string): bool = 
  return colorTerm in ["truecolor", "24bit"]

proc supports256Color(term: string): bool =
  return term.contains("256color")

proc supportsColor(term: string): bool =
  var colorTerms: seq[string]
  colorTerms = @["screen", "xterm", "vt100", "color", "ansi", "cygwin", "linux"]
  for t in colorTerms:
    if t.contains(term):
      return true
  return false


proc supports16Color(term: string): bool = 
  return term.contains("16color") or supportsColor(term)

proc supportsNone(term: string): bool = 
  return term == "dumb" or term.contains("mono")



# ================================
#  CHECKING TERMINAL ENVIRONMENT
# ================================

proc checkTermEnv(): tuple[cap: ColorCap, ok: bool] = 
  let term = getEnv("TERM")
  let colorTerm = getEnv("COLORTERM")
  #Check for explicit color number in $TERM or %COLORETERM
  if supportsTrueColor(colorTerm):
    return (cap: ColorTrue, ok: true)
  if supports256Color(term):
    return (cap: Color256, ok: true)
  if supports16Color(term):
    return (cap: Color16, ok: true)
  if supportsNone(term):
    return (cap: ColorNone, ok: true)
  
  #Detection failed
  return (cap: Unknown, ok: false)



#====================
# FORCE_COLOR
#====================

proc getForceColorLevel(): tuple[cap: ColorCap, ok: bool] = 
  let value = getEnv("FORCE_COLOR")
  if value == "":
    return (cap: Unknown, ok: false)
  
  case value
  of "0":
    return (cap: ColorNone, ok: true)
  of "1":
    return (cap: Color16, ok: true)
  of "2":
    return (cap: Color256, ok: true)
  of "3":
    return (cap: ColorTrue, ok: true)
  else:
    return (cap: Unknown, ok: false)


# =================
#  CI SYSTEMS
# =================

proc getCIColorLevel(): tuple[cap: ColorCap, ok: bool] =
  if not existsEnv("CI"):
    return (cap: Unknown, ok: false)
  
  if existsEnv("GITHUB_ACTIONS") or existsEnv("TRAVIS") or existsEnv("GITLAB_CI") or existsEnv("CIRCLECI"):
    return (cap: Color16, ok: true)
  else:
    return (cap: Unknown, ok: false)



# ====================
#  CHECK TERM_PROGRAM
# ====================

proc checkTermProgram(): tuple[cap: ColorCap, ok: bool] = 
  let value = getEnv("TERM_PROGRAM")
  if value == "":
    return (cap: Unknown, ok: false)
  
  case value
  of "iTerm.app", "WezTerm", "Hyper", "rio", "vscode", "tabby":
    return (cap: ColorTrue, ok: true)
  of "Apple_Terminal":
    return (cap: Color256, ok: true)
  else:
    return (cap: Unknown, ok: false)



# =====================
#  KNOWN TERMINALS
# =====================

proc getKnownTerminal(): tuple[cap: ColorCap, ok: bool] = 
  if existsEnv("WT_SESSION") or existsEnv("KONSOLE_VERSION") or existsEnv("ITERM_SESSION_ID") or existsEnv("VTE_VERSION"): 
    return (cap: ColorTrue, ok: true)
  else:
    return (cap: Unknown, ok: false)


# =====================
#  QUERYING TPUT
# =====================

proc queryTput(): tuple[cap: ColorCap, ok: bool] = 
  # Check if tput exists
  let findResult = findExe("tput")
  if findResult == "":
    return (cap: Unknown, ok: false)
  
  # Run tput colors
  let (output, exitCode) = execCmdEx("tput colors")
  if exitCode != 0:
    return (cap: Unknown, ok: false)
  
  let colors = parseInt(output.strip())
  if colors <= 0:
    return (cap: Unknown, ok: false)

  return (cap: ColorCap(colors), ok: true)



proc detectColorCap*(cachedArgs: seq[string], stream: File): ColorCap =

  # Check FORCE_COLOR level
  let force = getForceColorLevel()
  if force.ok:
    return force.cap
    
  # Check NO_COLOR env variable
  if existsEnv("NO_COLOR"):
    return ColorNone

  # Check if TTY
  if not isatty(stream):
    return ColorNone

  # Stream is a tty, now determine level  
  # CI Systems
  let ci = getCIColorLevel()
  if ci.ok:
    return ci.cap

  # Known Terminals
  let kt = getKnownTerminal()
  if kt.ok:
    return kt.cap
    
  # Check TERM_PROGRAM
  let termP = checkTermProgram()
  if termP.ok:
    return termP.cap

  # Check TERM
  let termEv = checkTermEnv()
  if termEv.ok:
    return termEv.cap

  # Query tput
  let tp = queryTput()
  if tp.ok:
    return tp.cap

  return ColorNone



























# WIP
# func windowsColorSupport() bool {
# 	_, exists := os.LookupEnv("ANSICON")
# 	return exists
# }


