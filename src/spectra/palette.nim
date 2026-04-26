import tables

let colorMap* = {
  # Foreground colors
  "fg=black":              "30",
  "fg=red":                "31",
  "fg=green":              "32",
  "fg=yellow":             "33",
  "fg=blue":               "34",
  "fg=magenta":            "35",
  "fg=cyan":               "36",
  "fg=white":              "37",
  "fg=darkgray":           "90",
  "fg=lred":           "91",
  "fg=lgreen":         "92",
  "fg=lyellow":        "93",
  "fg=lblue":          "94",
  "fg=lmagenta":       "95",
  "fg=lcyan":          "96",
  "fg=lwhite":         "97",
  

  # Background colors
  "bg=black":             "40",
  "bg=red":               "41",
  "bg=green":             "42",
  "bg=yellow":            "43",
  "bg=blue":              "44",
  "bg=magenta":           "45",
  "bg=cyan":              "46",
  "bg=white":             "47",
  "bg=darkgray":          "100",
  "bg=lred":          "101",
  "bg=lgreen":        "102",
  "bg=lyellow":       "103",
  "bg=lblue":         "104",
  "bg=lmagenta":      "105",
  "bg=lcyan":         "106",
  "bg=lwhite":        "107"
}.toTable

let resetMap* = {
  #these are the reset colors for foreground and background colors  
  "reset":               "0",  #reset all styles
  "fg=reset":            "39", #resets foreground colors
  "bg=reset":           "49", #reset background colors
  "bold=reset": "22",
  "dim=reset": "22",
  "italic=reset": "23",
  "underline=reset": "24",
  "blink=reset": "25",
  "blinkfast=reset": "26",
  "reverse=reset": "27",
  "hidden=reset": "28",
  "strike=reset": "29"
}.toTable

let styleMap* = {
  #styles
  "bold": "1", #bold/bright
  "dim": "2",   #dim/faint
  "italic": "3",
  "underline=single": "4",   #52 is also single underline
  "blink=slow": "5",  #slow blink
  "blink=fast": "6",  #fast blink #Some platforms show no difference between slow and fast blink
  "reverse": "7",
  "hidden": "8",
  "strike": "9" , #strike-through,
  "underline=double": "21"
}.toTable


#256-color palette to ansi16 lookup table adapted from jwalton (source: https://github.com/jwalton/gchalk/blob/master/pkg/ansistyles/ansi256lut.go)
var ansi256ToAnsi16Lut* = @[
  # Standard colors
  30, 31, 32, 33, 34, 35, 36, 37, 90, 91, 92, 93, 94, 95, 96, 97,
  # Colors
  30, 30, 30, 34, 34, 34, 30, 30, 34, 34, 34, 34, 32, 32, 90, 34, 34, 34,
  32, 32, 36, 36, 36, 36, 32, 32, 36, 36, 36, 36, 32, 32, 92, 36, 36, 36,
  30, 30, 30, 34, 34, 34, 30, 30, 90, 34, 34, 34, 32, 90, 90, 90, 94, 94,
  32, 32, 90, 36, 36, 94, 32, 32, 92, 36, 36, 96, 32, 92, 92, 92, 96, 96,
  30, 30, 90, 90, 34, 94, 31, 90, 90, 90, 94, 94, 90, 90, 90, 90, 94, 94,
  33, 90, 90, 90, 94, 94, 33, 92, 92, 92, 96, 96, 92, 92, 92, 92, 96, 96,
  31, 31, 90, 35, 35, 35, 31, 31, 90, 35, 35, 35, 31, 90, 90, 90, 94, 94,
  33, 33, 90, 37, 37, 94, 33, 33, 92, 37, 37, 37, 33, 92, 92, 92, 37, 96,
  31, 31, 31, 35, 35, 35, 31, 31, 91, 35, 35, 35, 31, 91, 91, 35, 35, 95,
  33, 33, 91, 37, 37, 95, 33, 33, 93, 37, 37, 37, 33, 93, 93, 93, 37, 97,
  31, 31, 91, 35, 35, 35, 31, 91, 91, 35, 35, 95, 31, 91, 91, 91, 95, 95,
  33, 91, 91, 91, 95, 95, 33, 93, 93, 93, 37, 97, 33, 93, 93, 93, 97, 97,
  # Greyscale
  30, 30, 30, 30, 30, 90, 90, 90, 90, 90, 90, 90,
  90, 90, 90, 37, 37, 37, 37, 37, 37, 37, 97, 97,
]

