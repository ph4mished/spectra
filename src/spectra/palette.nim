import tables

let paletteMap* = {
  #these are the reset colors for foreground and background colors  
  "reset":               "0", #reset all styles
  "fg=reset":            "39", #resets foreground colors
  "bg=reset":           "49", #reset background colors
   #"resetBold": "21", 2 is not mostly supported
  "bold=reset": "22",
  "dim=reset": "22",
  "italic=reset": "23",
  "underline=reset": "24",
  "blink=reset": "25",
  "blinkfast=reset": "26",
  "reverse=reset": "27",
  "hidden=reset": "28",
  "strike=reset": "29",


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
  "fg=lightred":           "91",
  "fg=lightgreen":         "92",
  "fg=lightyellow":        "93",
  "fg=lightblue":          "94",
  "fg=lightmagenta":       "95",
  "fg=lightcyan":          "96",
  "fg=lightwhite":         "97",

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
  "bg=lightred":          "101",
  "bg=lightgreen":        "102",
  "bg=lightyellow":       "103",
  "bg=lightblue":         "104",
  "bg=lightmagenta":      "105",
  "bg=lightcyan":         "106",
  "bg=lightwhite":        "107",

  #styles
  "bold": "1", #bold/bright
  "dim": "2",   #dim/faint
  "italic": "3",
  "underline": "4",
  "blink": "5",  #slow blink
  "blinkfast": "6",  #fast blink
  "reverse": "7",
  "hidden": "8",
  "strike": "9"  #strike-through
}.toTable



