import os
import detect, flags





proc getColorFlagCap(cachedArgs: seq[string], colorCap: ColorCap): ColorCap = 
  #Check --color flags
  if checkColorToggle(cachedArgs, "color", "=", colorPosArgs):
    if colorCap != ColorNone:
      return colorCap
    #Force color on
    return Color16
  
  # Check --color=auto flags
  if checkColorToggle(cachedArgs, "color", "=", colorAutoArgs):
    return colorCap

  # Check --no-color flags
  if checkColorToggle(cachedArgs, "no-color", "=", colorNegArgs) or checkColorToggle(cachedArgs, "color", "=", colorNegArgs) or checkColorToggle(cachedArgs, "no-color", "=", colorPosArgs):
    return ColorNone

  return ColorNone


proc Capability*(stream: File = stdout, sniffFlags: bool = true): ColorCap =
  let cachedArgs = commandLineParams()

  var colorCap = detectColorCap(cachedArgs, stream)

  if sniffFlags:
    colorCap = getColorFlagCap(cachedArgs, colorCap)
  
  return colorCap




