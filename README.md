# Spectra

**Spectra** is a library for terminal text coloring and formatting.

# Installation
``` nim
nimble install spectra
```

# Features
1. It supports granular resets, Only what you close resets (foreground, background, or text styles) as well as one-for-all reset (reset).
2. Support for multiple color systems {basic ANSI colors, hex colors and 256-color Palette}.
3. Spectra uses [ ]-enclosed syntax but its not an owned syntax. **Users are free to use "[ ]" for anything of their choice without needing escapes, only if its content does not count as spectra tag/color.**
 
**Spectra has true color support**, depending on your terminal's true color support. This is achieved through its hex colors.

When true-color is not available, **hex colors will not be rendered**

# Limitation
At the moment, spectra lacks support for windows, hence its not cross-platform(only native to linux and possibly macos).

# Usage
**Spectra supports more than one color tags in its square brackets bounded syntax (but one bad nut spoils all).** It means spectra supports 
``` nim
paint("[fg=white][bold italic strike fg=cyan]Hello World[reset]")
#This will work perfectly 
```
**but a typo goes unforgiven**
```nim
paint("[fg=white][bld italic strike fg=cyan]Hello World[reset]")

#"bld" is the bad nut, so all other tags enclosed in same [] are treated as literals.
#hence it prints "[bld italic strike fg=cyan]Hello World" colored white due to the first color (fg=white). 
```

# Importing the package
``` nim
import spectra
```

## Usage Examples
```nim
import spectra

#Multiple styles in one tag
paint("[bold italic fg=red]Important![reset]")

#Granular reset control
paint("[bold fg=red bg=blue]Alert[bold=reset] Still colored[fg=reset bg=reset] Normal")

#Hex colors
paint("[fg=#FF0000]Red text[fg=#00FF00]Green text[reset]")

#256 colors
paint("[fg=202]Orange text[fg=45]Blue text[reset]")


#Style example
paint "[bold bg=yellow fg=cyan hidden]Sorry can't find me[hidden=reset]Oops! I've being caught[reset]"
```



# Coloring a text
``` nim
paint "[bold][fg=yellow]Hello Word[reset]"

paint "[bold fg=red]Error:[bold=reset] File not found[reset]"

#hex color
paint "[fg=#FF0000 underline]DANGER[fg=reset underline=reset]"

# 256 color support
paint "                        [fg=255 bg=24]┌────────────────────┐[reset]"
paint "                        [fg=255 bg=24]│     Submit         │[reset]"
paint "                        [fg=255 bg=24]└────────────────────┘[reset]"

```

# System Messages
``` nim
paint "[bold fg=white bg=#FF6B6B]CRITICAL[reset] CPU at 95%"
paint "[bold fg=black bg=#F9C74F]WARNING[bold=reset bg=reset] Memory usage high[reset]"
```

# Cli Tools
``` nim
paint "[bold fg=cyan]Usage:[fg=reset fg=green] ./tool [OPTIONS] [reset]"

#or
paint "[bold][fg=cyan]Usage: [fg=reset][fg=green] ./tool [OPTIONS] [reset]"
```

# Color Toggling
## Global Master Switch
``` nim
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
let greet = paint("[bold fg=green]GOOD DAY![reset]", toStdout=false)
echo greet &  "World!"
```

# Spectra In Action
``` nim
paint """[bold fg=magenta]Spectra[bold=reset]
         brings [fg=cyan]colors[fg=reset] to life!
         [fg=red]also[fg=yellow]in[fg=green]a[fg=blue]human[fg=#6600FF]friendly[fg=magenta]way[reset]
         """
```

## Beauty Of Spectra
``` nim
#This example is to express how spectra can be used for ascii arts

# Create gradient-like effects with multiple colors
#to recreate the unicode block below
#to recreate the unicode block below
#for linux, enter "Ctrl + Shift + u" and then type "2592" and press enter
paint("""
[fg=#FF0000]▓▓▓[fg=#FF3300]▓▓▓[fg=#FF6600]▓▓▓[fg=#FF9900]▓▓▓[fg=#FFCC00]▓▓▓[reset]
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



# Spectra Syntax Reference

## Basic Colors
**Foreground Colors**
| Command | Effect |
|---------|--------|
| `fg=black` | Black text |
| `fg=red` | Red text |
| `fg=green` | Green text |
| `fg=yellow` | Yellow text |
| `fg=blue` | Blue text |
| `fg=magenta` | Magenta text |
| `fg=cyan` | Cyan text |
| `fg=white` | White text |
| `fg=darkgray` | Dark gray text |
| `fg=lightred` | Light red text |
| `fg=lightgreen` | Light green text |
| `fg=lightyellow` | Light yellow text |
| `fg=lightblue` | Light blue text |
| `fg=lightmagenta` | Light magenta text |
| `fg=lightcyan` | Light cyan text |
| `fg=lightwhite` | Light white text |


**Background Colors**
| Command | Effect |
|---------|--------|
| `bg=black` | Black background |
| `bg=red` | Red background |
| `bg=green` | Green background |
| `bg=yellow` | Yellow background |
| `bg=blue` | Blue background |
| `bg=magenta` | Magenta background |
| `bg=cyan` | Cyan background |
| `bg=white` | White background |
| `bg=darkgray` | Dark gray background |
| `bg=lightred` | Light red background |
| `bg=lightgreen` | Light green background |
| `bg=lightyellow` | Light yellow background |
| `bg=lightblue` | Light blue background |
| `bg=lightmagenta` | Light magenta background |
| `bg=lightcyan` | Light cyan background |
| `bg=lightwhite` | Light white background |


## Text Styles
| Command | Effect |
|---------|--------|
| `bold` | Bold/bright text |
| `dim` | Dim/faint text |
| `italic` | Italic text |
| `underline` | Underlined text |
| `blink` | Slow blinking text |
| `blinkfast` | Fast blinking text |
| `reverse` | Reverse video (swap foreground and background colors) |
| `hidden` | Hidden text |
| `strike` | Strikethrough text |

## Reset Commands
| Command | Effect |
|---------|--------|
| `reset` | Reset all colors and styles |
| `fg=reset` | Reset foreground color only |
| `bg=reset` | Reset background color only |
| `bold=reset` | Reset bold style only |
| `dim=reset` | Reset dim style only |
| `italic=reset` | Reset italic style only |
| `underline=reset` | Reset underline style only |
| `blink=reset` | Reset blink style only |
| `blinkfast=reset` | Reset fast blink style only |
| `reverse=reset` | Reset reverse style only |
| `hidden=reset` | Reset hidden style only |
| `strike=reset` | Reset strikethrough style only |


## Advanced Features
| Command | Effect |
|---------|--------|
| `fg=#RRGGBB` | Hex color for foreground |
| `bg=#RRGGBB` | Hex color for background |
| `fg=NNN` | 256-color palette (0-255) for foreground |
| `bg=NNN` | 256-color palette (0-255) for background |

