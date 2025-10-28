import tables

let resetMap* = {  
  # Default colors
  #these are the reset colors for foreground and background colors  
  #these defaults can be replaced by preppending / to the doreground colors and background colors
  "reset":               "0", #reset all styles it could be replaced by this [/]
  "fgReset":            "39", #resets foreground colors
  "bgReset":           "49", #reset background colors
  }.toTable

let colorMap* = {
  # Foreground colors
  "black":              "30",
  "red":                "31",
  "green":              "32",
  "yellow":             "33",
  "blue":               "34",
  "magenta":            "35",
  "cyan":               "36",
  "white":              "37",
  "darkGray":           "90",
  "lightRed":           "91",
  "lightGreen":         "92",
  "lightYellow":        "93",
  "lightBlue":          "94",
  "lightMagenta":       "95",
  "lightCyan":          "96",
  "lightWhite":         "97",

  # Background colors
  "bgBlack":             "40",
  "bgRed":               "41",
  "bgGreen":             "42",
  "bgYellow":            "43",
  "bgBlue":              "44",
  "bgMagenta":           "45",
  "bgCyan":              "46",
  "bgWhite":             "47",
  "bgDarkGray":          "100",
  "bgLightRed":          "101",
  "bgLightGreen":        "102",
  "bgLightYellow":       "103",
  "bgLightBlue":         "104",
  "bgLightMagenta":      "105",
  "bgLightCyan":         "106",
  "bgLightWhite":        "107"
    }.toTable

let styleMap* = {
  "bold": "1", #bold/bright
  "dim": "2",   #dim/faint
  "italic": "3",
  "underline": "4",
  "blink": "5",  #slow blink
  "blinkFast": "6",  #fast blink
  "reverse": "7",
  "hidden": "8",
  "strike": "9",  #strike-through
  #"resetBold": "21", 2 is not mostly supported
  "resetBold": "22",
  "resetDim": "22",
  "resetItalic": "23",
  "resetUnderline": "24",
  "resetBlink": "25",
  "resetBlinkFast": "26",
  "resetReverse": "27",
  "resetHidden": "28",
  "resetStrike": "29"
  }.toTable


