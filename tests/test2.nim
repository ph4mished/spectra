#Test for helper functions
import unittest
include spectra/[color_helpers, palette]

#[
- 
]#

suite "INPUT VALIDITY":
  test "VALID HEX CODES":
    #Uppercase
    check isValidHex("fg=#FFGGHH") == false
    check isValidHex("fg=#AABBCC") == true

    #Lowercase
    check isValidHex("fg=#ffgghh") == false
    check isValidHex("fg=#aabbcc") == true

    #Mixed cases
    check isValidHex("fg=#FfGGhH") == false
    check isValidHex("fg=#aABbCC") == true

  test "VALID 256 CODES":
    check isValid256Code("fg=2020") == false
    check isValid256Code("bg=-12") == false
    check isValid256Code("fg=204") == true
    check isValid256Code("fg=12") == true


suite "SUPPORTED???":
  test "TRUE COLOR SUPPORT":
    putEnv("COLORTERM", "")
    check supportsTrueColor() == false

    putEnv("COLORTERM", "truecolor")
    check supportsTrueColor() == true

  test "ACCEPTABLE COLOR CODES":
    check  isSupportedColor("red") == false
    check isSupportedColor("#aabbcc") == false
    check isSupportedColor("hello world") == false
    check isSupportedColor("fg=2025") == false

    #Supported colors
    check isSupportedColor("fg=red") == true
    check isSupportedColor("fg=#aabbcc") == true
    check isSupportedColor("fg=202") == true


suite "PARSE COLOR CODES":
  test "PARSE HEX COLOR CODES":
    check parseHexToAnsiCode("fg=#aabbcc") == "\e[38;2;170;187;204m"
    check parseHexToAnsiCode("bg=#aabbcc") == "\e[48;2;170;187;204m"

  test "PARSE 256 COLOR CODES":
    check parse256ColorCode("fg=202") == "\e[38;5;202m"
    check parse256ColorCode("bg=202") == "\e[48;5;202m"

  test "PARSE ANSI COLOR CODES":
    check parseColor("fg=red") == "\e[31m"
    check parseColor("bg=blue") == "\e[44m"
    check parseColor("bold") == "\e[1m"
    check parseColor("fg=reset") == "\e[39m"

  

    