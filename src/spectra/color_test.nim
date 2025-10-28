import unittest

include color

suite "Color Validation":
  test "isValidHex - valid hex codes":
    check isValidHex("FF0000") == true
    check isValidHex("DDDDEE") == true
    check isValidHex("666555") == true

  test "isValidHex - invalid hex codes":
    check isValidHex("ZZXXYY") == false
    check isValidHex("AAFF") == false
    check isValidHex("123") == false
    check isValidHex("") == false

  test "isValid256Code":
    check isValid256Code("0") == true
    check isValid256Code("255") == true
    check isValid256Code("258") == false
    #check isValid256Code("hello") == false #invalid integer error caught it
    check isValid256Code("-255")  == false


suite "Color Parsing":
  test "parseHexToAnsi - foreground":
    check parseHexToAnsiCode("fg=#FF0000") == "\e[38;2;255;0;0m"


suite "Supported Color": 
  test "Supported Color Check":
    isSupportedColor("fg=red") == true
    isSupportedColor("bg=red") == true
    isSupportedColor("fg=#FFEEBB") == true
    isSupportedColor("bg=#FFEEBB") == true
    isSupportedColor("fg=255") == true
    isSupportedColor("bg=255") == true
    

suite "Test Color Escape":
  test "Check Escapes":
      
