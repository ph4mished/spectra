#Test for helper functions
import unittest, os, strutils, strformat
include spectra/[color_helpers, palette]

#[
- 
]#
#[
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

]#

# =============================
# RGB TO 256 INDEX TESTS
# =============================

suite "RGB TO 256 INDEX TESTS":
  test "RGB TO 256 INDEX BASIC COLORS":
    let tests = [
      (r: 0, g: 0, b: 0, expected: 16, desc: "black"),
      (r: 255, g: 255, b: 255, expected: 255, desc: "white"),
      (r: 255, g: 0, b: 0, expected: 196, desc: "red"),
      (r: 0, g: 255, b: 0, expected: 46, desc: "green"),
      (r: 0, g: 0, b: 255, expected: 21, desc: "blue"),
      (r: 128, g: 128, b: 128, expected: 244, desc: "gray fallback"),
      (r: 255, g: 255, b: 0, expected: 226, desc: "yellow"),
      (r: 255, g: 0, b: 255, expected: 201, desc: "magenta"),
      (r: 0, g: 255, b: 255, expected: 51, desc: "cyan"),
    ]

    for test in tests:
      let result = rgbTo256Index(test.r, test.g, test.b)
      check result == test.expected

      if result != test.expected:
        echo fmt "{test.desc}: rgbTo256Index({test.r},{test.g},{test.b}) = {result} expected {test.expected}"


  test "RGB TO 256 INDEX GRAYSCALE":
    let result = rgbTo256Index(100, 100, 100)
    check result in 232..255


# =============================
# PREFIX VALIDATION TESTS
# =============================

suite "PREFIX VALIDATION TESTS":
  test "HAS VALID PREFIX":
    let tests = [
      (input: "fg=red", expected: true),
      (input: "bg=blue", expected: true),
      (input: "fg=#FF0000", expected: true),
      (input: "bg=rgb(255,0,0)", expected: true),
      (input: "bold", expected: false),
      (input: "underline", expected: false),
      (input: "", expected: false),
      (input: "invalid", expected: false),
    ]

    for test in tests:
      let result = hasValidPrefix(test.input)
      check result == test.expected
      #if result != test.expected:
       # echo fmt "hasValidPrefix({test.input}) = {result}, expected {test.expected}"


# =============================
# HEX CODE TESTS
# =============================
suite "HEX CODE TESTS":
#[
  test "IS HEX CODE":
    let tests = [
      (input: "FF0000", expected: true),
      (input: "00ff00", expected: true),
      (input: "123abc", expected: true),
      (input: "ABCDEF", expected: true),
      (input: "GHIJKL", expected: false),
      (input: "12345", expected: true),
      (input: "", expected: true), # empty string passes (edge case)
      (input: "12 34", expected: false),
    ]

    for test in tests:
      let result = isHexCode(test.input)
      check result == test.expected]#


  test "IS VALID HEX":
    let tests = [
      (input: "fg=#FF0000", expected: true),
      (input: "fg=#00ff00", expected: true),
      (input: "fg=#123456", expected: true),
      (input: "bg=#FF0000", expected: true),
      (input: "fg=FF00", expected: false),
      (input: "fg=GHIJKL", expected: false),
      (input: "fg=", expected: false),
      (input: "bg=", expected: false),
      (input: "fg=FFFFFFF", expected: false),
      (input: "bold", expected: false),
    ]

    for test in tests:
      let result = isValidHex(test.input)
      check result == test.expected



# =============================
# 256 COLOR CODE TESTS
# =============================
suite "256 COLOR CODE TESTS":
  test "IS VALID 256 CODE":
    let tests = [
      (input: "fg=0", expectedVal: 0, expectedOk: true),
      (input: "fg=255", expectedVal: 255, expectedOk: true),
      (input: "fg=128", expectedVal: 128, expectedOk: true),
      (input: "bg=196", expectedVal: 196, expectedOk: true),
      (input: "fg=256", expectedVal: 0, expectedOk: false),
      (input: "fg=-1", expectedVal: 0, expectedOk: false),
      (input: "fg=abc", expectedVal: 0, expectedOk: false),
      (input: "fg=", expectedVal: 0, expectedOk: false),
      (input: "bold", expectedVal: 0, expectedOk: false),
      (input: "fg=1000", expectedVal: 0, expectedOk: false),
    ]

    for test in tests:
      let result = isValid256Code(test.input)
      check result.ok == test.expectedOk
      if result.ok:
        check result.value == test.expectedVal

# =============================
# RGB VALIDATION TESTS
# =============================
suite "TEST IS VALID RGB":
  test "IS VALID RGB":
    let tests = [
      (input: "fg=rgb(255,0,0)", expectedOk: true, expectedLen: 3), 
      (input: "fg=rgb(0,255,0)", expectedOk: true, expectedLen: 3), 
      (input: "fg=rgb(0,0,255)", expectedOk: true, expectedLen: 3), 
      (input: "bg=rgb(128,128,128)", expectedOk: true, expectedLen: 3), 
      (input: "fg=rgb(300,0,0)", expectedOk: false, expectedLen: 0), 
      (input: "fg=rgb(-1,0,0)", expectedOk: false, expectedLen: 0), 
      (input: "fg=rgb(255,0)", expectedOk: false, expectedLen: 0), 
      (input: "fg=rgb(255,0,0,0)", expectedOk: false, expectedLen: 0), 
      (input: "fg=rgb(abc,0,0)", expectedOk: false, expectedLen: 0), 
      (input: "fg=rgb(0,0,abc)", expectedOk: false, expectedLen: 0), 
      (input: "fg=rgb(255,0,0", expectedOk: false, expectedLen: 0), 
      (input: "bold", expectedOk: false, expectedLen: 0),
    ]

    for test in tests:
      let result = isValidRGB(test.input)
      check result.ok == test.expectedOk
      if result.ok:
        check result.values.len == test.expectedLen



# =============================
# TERMINAL SUPPORT DETECTION
# =============================
suite "TERMINAL SUPPORT DETECTION":
  setup:
    let origColorterm = os.getEnv("COLORTERM")
  teardown:
    os.putEnv("COLORTERM", origColorterm)
  
  test "SUPPORT TRUE COLOR":
    let tests = [
      (colorterm: "truecolor", expected: true),
      (colorterm: "24bit", expected: true),
      (colorterm: "", expected: false),
      (colorterm: "256color", expected: false),
      (colorterm: "something", expected: false),
    ]

    for test in tests:
      os.putEnv("COLORTERM", test.colorterm)
      let result = supportsTrueColor()
      check result == test.expected

  test "SUPPORT 256 COLOR":
    let origTerm = os.getEnv("TERM")
    defer: os.putEnv("TERM", origTerm)

    let tests = [
      (colorTerm: "xterm-256color", expected: true),
      (colorTerm: "screen-256color", expected: true),
      (colorTerm: "xterm", expected: false),
      (colorTerm: "vt100", expected: false),
      (colorTerm: "", expected: false),
    ]

    for test in tests:
      os.putEnv("TERM", test.colorTerm)
      let result = supports256Color()
      check result == test.expected


# =============================
# IS SUPPORTED COLOR TESTS
# =============================
suite "IS SUPPORTED COLOR TESTS":
  test "IS SUPPORTED COLOR":
    let tests = [
      # Named colors
      (input: "fg=red", expected: true),
      (input: "bg=blue", expected: true),
      (input: "bold", expected: true),
      (input: "underline=single", expected: true),

      # Resets
      (input: "reset", expected: true),
      (input: "fg=reset", expected: true),
      (input: "bg=reset", expected: true),

      # Hex colors
      (input: "fg=#FF0000", expected: true),
      (input: "bg=#00FF00", expected: true),

      # 256 colors
      (input: "fg=196", expected: true),
      (input: "bg=255", expected: true),

      # RGB colors
      (input: "fg=rgb(255,0,0)", expected: true),
      (input: "bg=rgb(0,255,0)", expected: true),

      # Invalid
      (input: "invalid", expected: false),
      (input: "", expected: false),
      (input: "fg=", expected: false),
      (input: "bg=", expected: false),
    ]

    for test in tests:
      let result = isSupportedColor(test.input)
      check result == test.expected


# =============================
# PARSE RGB TESTS
# =============================
suite "EXTRACT RGB TESTS":
  test "EXTRACT RGB":
    let tests = [
      (input: "fg=rgb(255,0,0)", expectedVal: @[255, 0, 0], expectedOk: true),
      (input: "fg=rgb(0,255,0)", expectedVal: @[0, 255, 0], expectedOk: true),
      (input: "fg=rgb(128,128,128)", expectedVal: @[128, 128, 128], expectedOk: true),
      (input: "fg=rgb(255,0,0,0)", expectedVal: @[], expectedOk: false),
      (input: "fg=rgb(255,0)", expectedVal: @[], expectedOk: false),
      (input: "fg=rgb(abc,0,0)", expectedVal: @[], expectedOk: false),
    ]

    for test in tests:
      let result = extractRGB(test.input)
      check result.ok == test.expectedOk 
      if result.ok:
        check result.values == test.expectedVal

# =============================
# PARSE ANSI TESTS
# =============================
suite "PARSE ANSI TESTS":
  test "PARSE ANSI 16 FOREGROUND":
    let result = parseAnsi16("fg=cyan", "36")
    check result == "\e[36m"

  test "PARSE ANSI 16  BACKGROUND":
    let result = parseAnsi16("bg=31", "90")
    check result == "\e[100m"

  test "PARSE ANSI FOREGROUND":
    let result = colorMap.getOrDefault("fg=red", "")
    check result == "31"

  test "PARSE ANSI BACKGROUND":
    let result = colorMap.getOrDefault("bg=blue")
    check result == "44"
  
  test "PARSE ANSI FOREGROUND TRUECOLOR":
    let result = parseAnsi("fg=red", "2;255;0;0")
    check result == "\e[38;2;255;0;0m"

  test "PARSE ANSI BACKGROUND TRUECOLOR":
    let result = parseAnsi("bg=blue", "2;0;0;255")
    check result == "\e[48;2;0;0;255m"

  test "PARSE ANSI INVALID":
    let result = parseAnsi("invalid", "31")
    check result == ""

# =============================
# RGB TO ANSI CODE TESTS
# =============================
suite "RGB TO ANSI CODE TESTS":
  test "PARSE RGB TO ANSI CODE":
    let rgb = @[255,0,0]
    let result = parseRGBToAnsiCode("fg=rgb(255,0,0)", rgb)
    check result != ""
    check result.startsWith("\e[")

# =============================
# HEX TO ANSI CODE TESTS
# =============================
suite "HEX TO ANSI CODE TESTS":
  test "PARSE HEX TO ANSI CODE":
    let result = parseHexToAnsiCode("fg=#FF0000")
    check result != ""
    check result.startsWith("\e[")

# =============================
# PARSE COLOR TESTS
# =============================
suite "PARSE COLOR TESTS":
  test "PARSE COLOR NAMED COLORS":
    let tests = [
      "fg=red", "fg=blue", "fg=green", "fg=yellow",
      "bg=red", "bg=blue", "bg=green",
    ]

    for test in tests:
      let result = parseColor(test)
      check result != ""
      check result.startsWith("\e[")

  test "PARSE COLOR STYLES":
    let tests = [
      "bold", "italic", "underline=single", "dim", "strike",
    ]

    for test in tests:
      let result = parseColor(test)
      check result != ""

  test "PARSE COLOR RESETS":
    let tests = [
      "reset", "fg=reset", "bg=reset", "bold=reset",
    ]

    for test in tests:
      let result = parseColor(test)
      check result != ""

  test "PARSE COLOR 256 COLORS":
    let tests = [
      "fg=196", "fg=255", "fg=0", "bg=196", "bg=255",
    ]

    for test in tests:
      let result = parseColor(test)
      check result != ""

  test "PARSE COLOR HEX COLORS":
    let tests = [
      "fg=#FF0000", "fg=#00FF00", "fg=#0000FF",
      "bg=#FF0000", "bg=#00FF00", "bg=#0000FF",
    ]

    for test in tests:
      let result = parseColor(test)
      check result != ""

  test "PARSE COLOR RGB COLORS":
    let tests = [
      "fg=rgb(255,0,0)",
      "fg=rgb(0,255,0)",
      "fg=rgb(0,0,255)",
      "bg=rgb(255,0,0)"
    ]

    for test in tests:
      let result = parseColor(test)
      check result != ""


  test "PARSE COLOR INVALID":
    let tests = [
      "invalid",
      "",
      "fg=",
      "bg=",
      "fg=invalid",
    ]

    for test in tests:
      let result = parseColor(test)
      check result == ""


# =============================
# BENCHMARK TESTS
# =============================
#[
func BenchmarkRgbTo256Index(b *testing.B) {
	for i := 0; i < b.N; i++ {
		rgbTo256Index(128, 128, 128)
	}
}

func BenchmarkParseColor(b *testing.B) {
	colors := []string{
		"fg=red",
		"fg=rgb(255,0,0)",
		"fg=FF0000",
		"fg=196",
		"bold",
		"reset",
	}

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		for _, color := range colors {
			parseColor(color)
		}
	}
}

func BenchmarkIsValidRGB(b *testing.B) {
	for i := 0; i < b.N; i++ {
		isValidRGB("fg=rgb(255,128,64)")
	}
}

func BenchmarkIsValidHex(b *testing.B) {
	for i := 0; i < b.N; i++ {
		isValidHex("fg=FFAABB")
	}
}]#