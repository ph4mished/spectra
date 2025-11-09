# Spectra

**Spectra** is a library for text coloring and formatting.

# Installation
``` nim
nimble install spectra
```

# Features
1. It supports granular resets, Only what you close resets (foreground, background, or text styles) as well as one-for-all reset (reset).
2. Support for multiple color systems {basic ANSI colors, hex colors and 256-color Palette}.

# Weakness
At the moment, spectra lacks windows and mac os support, hence its not cross-platform(only native to linux).

# Usage
**Spectra supports more than one color tags in its square brackets bounded tags.**

# Importing the package
``` nim
import spectra
```

# Coloring a text
``` nim
paint "[bold][fg=yellow]Hello Word[reset]"

paint "[bold fg=red]Error:[bold=reset] File not found[reset]

#hex color
paint [fg=#FF0000 underline]DANGER[fg=reset underline=reset]

# 256 color support
paint "                        [fg=255 bg=24]┌────────────────────┐[reset]"
paint "                        [fg=255 bg=24]│     Submit         │[reset]"
paint "                        [fg=255 bg=24]└────────────────────┘[reset]"

```

# System Messages
``` nim
paint "[bold fg=white bg=#FF6B6B]CRITICAL[reset] CPU at 95%"
paint "[bold fg=black bg=#F9C74F]WARNING [bold=reset bg=reset] Memory usage high[reset]"
```

# Cli Tools
``` nim
paint "[bold fgcyan]Usage:[fg=reset fg=green] ./tool [OPTIONS] [reset]"

#or
paint "[bold][fg=cyan]Usage: [fg=reset][fg=green] ./tool [OPTIONS] [reset]"
```

# Color Toggling
## Global Master Switch
``` nim
import terminal
#colorToggle is the global switch for huewheel color
colorToggle = stdout.isatty()

paint "[fg=red]ERROR[reset]"
import terminal  #imported for stdout.isatty()
#colorToggle is the global switch for spectra color
colorToggle = stdout.isatty()

#prints only "ERROR" without color when its redirected to file or to another tool.
paint "[fg=red]ERROR[reset]"


#color on
colorToggle = true
paint "[fg=green]Development Mode[reset]"

#color off
colorToggle = false
paint "[fg=green]Sorry, I can't be colored[reset]"

#respect for no color
colorToggle= not paramStr(1) == "--no-color"
paint("[fg=green]Ready[reset]")
```

## Per-Call (global toggle override)
``` nim
#Force color (override global setting)
#colorToggle will be called for global setting
colorToggle = false

#colorToggle is used for per call control or to override enabledColor control
#forceColor is used for per paint() call color control or to override colorToggle control
paint("[bold italic strike fg=yellow]WARNING[reset]")

paint("[fg=red]ALWAYS RED[reset]", forceColor=true)

paint("[fg=blue]COLOR DEPENDS[reset]", forceColor=stdout.isatty())
```

# Output Control
## Printing Color To Stdout
``` nim
paint("[bold fg=cyan]WELCOME![reset]")
```

## Return Results (Does not print)
``` nim
let name = paint("[bold fg=green]GOOD BYE![reset]", toStdout=false)
echo name
```

# Spectra In Action
``` nim
paint """[bold fg=magenta]Spectra[bold=reset]
         brings [fg=cyan]colors[fg=reset] to life!
         [fg=red][#FF6600]also[fg=yellow]in[fg=green]a[fg=blue]human[fg=#6600FF]friendly[fg=magenta]way[reset]
         """
```

## Beauty Of Spectra
``` nim
#This example is to express how spectra can be used for ascii arts

# Create gradient-like effects with multiple colors
#to recreate the uniocde block below
#to recreate the unicode block below
#for linux, enter "Ctrl + Shift + u" and then type "2592" and press enter
paint("""
[fg=#FF0000]▓▓▓[fg=#FF3300]▓▓▓[fg=#FF6600]▓▓▓[fg=#FF9900]▓▓▓[f#FFCC00]▓▓▓[reset]
[fg=#CC0000]▓▓▓[fg=#CC3300]▓▓▓[fg=#CC6600]▓▓▓[fg=#CC9900]▓▓▓[fg=#CCCC00]▓▓▓[reset]
[fg=#990000]▓▓▓[fg=#993300]▓▓▓[fg=#996600]▓▓▓[fg=#999900]▓▓▓[fg=#99CC00]▓▓▓[reset]
""")

# Simple colored blocks and patterns
#to recreate the unicode block below
#for linux, enter "Ctrl + Shift + u" and then type "2588" and press enter
paint("""
[fg=red]████████[fg=green]████████[fg=blue]████████[reset]
[fg=red]████████[fg=green]████████[fg=blue]████████[reset]
[fg=yellow]████████[fg=magenta]████████[fg=cyan]████████[reset]
""")

paint("""
[fg=red]R[fg=#FF6600]A[fg=yellow]I[fg=green]N[fg=blue]B[fg=#6600FF]O[fg=magenta]W[reset]

[fg=red]▄▄▄▄▄[fg=#FF6600]▄▄▄▄▄[fg=yellow]▄▄▄▄▄[fg=green]▄▄▄▄▄[fg=blue]▄▄▄▄▄[fg=#6600FF]▄▄▄▄▄[fg=magenta]▄▄▄▄▄[reset]
""")


#ctrl+ shift+u + 250c = ┌
#ctrl+ shift+u + 2514 = └
#ctrl+ shift+u + 2518 = ┘
#ctrl+ shift+u + 2510 = ┐
#ctrl+ shift+u + 2500 = ─
#ctrl+ shift+u + 2502 = │
paint "[fg=255 bg=24]┌────────────────────┐[reset]"
paint "[fg=255 bg=24]│     Submit         │[reset]"
paint "[fg=255 bg=24]└────────────────────┘[reset]"
```

## Results
![beauty](/example_result/beauty.png)


