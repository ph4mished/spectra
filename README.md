# Spectra

**Spectra** is a library for text coloring and formatting.

# Installation
``` nim
nimble install spectra
```

# Features
1. **Smart Parsing** - Spectra knows the difference between text and color tags. No accidental parsing of [ERROR], [INFO]  or other square bracket bounded words as colors.
2. It also supports granular resets, Only what you close resets (foreground, background, or text styles) as well as one-for-all reset (reset).
3. Support for multiple color systems {basic ANSI colors, hex colors and 256-color Palette}.

# Weakness
At the moment, spectra lacks windows and mac os support, hence its not cross-platform(only native to linux).

# Usage
<<<<<<< HEAD
Spectra supports more than one color tags in its square brackets bounded tags.
=======
**Spectra supports more than one color tags in its square brackets bounded tags.**
>>>>>>> fadb77f (Revised color and style syntax)

# Importing the package
``` nim
import spectra
```

# Coloring a text
``` nim
paint "[bold][yellow]Hello Word[reset]"

paint "[bold red]Error:[/bold] File not found[/red]

#hex color
paint [#FF0000 underline]DANGER[/#FF0000 /underline]

# 256 color support
paint "                        [c=255 bg=24]┌────────────────────┐[reset]"
paint "                        [c=255 bg=24]│     Submit         │[reset]"
paint "                        [c=255 bg=24]└────────────────────┘[reset]"

```

# System Messages
``` nim
paint "[bold white bg=#FF6B6B]CRITICAL[reset] CPU at 95%"
paint "[bold black bg=#F9C74F]WARNING [/bold /bg=#F9C74F] Memory usage high[/black]"
```

# Cli Tools
``` nim
paint "[bold cyan]Usage:[/cyan green] ./tool [OPTIONS] [/green /bold]"

#or
paint "[bold][cyan]Usage: [/cyan][green] ./tool [OPTIONS] [reset]"
```

# Color Toggling
## Global Master Switch
``` nim
<<<<<<< HEAD
import terminal
#colorEnabled is the global switch for huewheel color
colorEnabled = stdout.isatty()

paint "[red]ERROR[/red]"
=======
import terminal  #imported for stdout.isatty()
#colorToggle is the global switch for spectra color
colorToggle = stdout.isatty()

>>>>>>> fadb77f (Revised color and style syntax)
#prints only "ERROR" without color when its redirected to file or to another tool.
paint "[red]ERROR[/red]"


#color on
colorToggle = true
paint "[green]Development Mode[reset]"

#color off
<<<<<<< HEAD
colorEnabled = false
=======
colorToggle = false
>>>>>>> fadb77f (Revised color and style syntax)
paint "[green]Sorry, I can't be colored[/green]"

#respect for no color
colorToggle= not paramStr(1) == "--no-color"
paint("[green]Ready[/green]")
```

## Per-Call (global toggle override)
``` nim
#Force color (override global setting)
#colorToggle will be called for global setting
colorToggle = false

<<<<<<< HEAD
#colorToggle is used for per call control or to override enabledColor control
=======
#forceColor is used for per paint() call color control or to override colorToggle control
>>>>>>> fadb77f (Revised color and style syntax)
paint("[bold italic yellow]WARNING[reset]")

paint("[red]ALWAYS RED[/red]", forceColor=true)

paint("[blue]COLOR DEPENDS[/blue]", forceColor=stdout.isatty())
```

# Smart Bracket Handling
``` nim
paint "[cyan][[magenta]OPTIONS[/magenta][cyan]]
```

# Output Control
## Printing Color To Stdout
<<<<<<< HEAD
``` nim
paint("[bold cyan]WELCOME![reset]")
```

## Return Results (Does not print)
``` nim
let name = paint("[bold green]GOOD BYE![reset]", toStdout=false)
echo name
```

# HueWheel In Action
=======
>>>>>>> fadb77f (Revised color and style syntax)
``` nim
paint("[bold cyan]WELCOME![reset]")
```

## Return Results (Does not print)
``` nim
let name = paint("[bold green]GOOD BYE![reset]", toStdout=false)
echo name
```

# Color Escapes
**Color escape** "!" is meant to be used where a user wants to print a literal in square brackets but the said literal is also a word found in the color or style table. 
``` nim
paint("[blue][NOTE]: Errors are always displayed in [!red][reset]")
#this outputs "[NOTE]: Errors are always displayed in [red]"
```

# Spectra In Action
``` nim
paint """[bold magenta]Spectra[/bold]
         brings [cyan]colors[/cyan] to life!
         [red]And[/red][#FF6600]also[/#FF6600][yellow]in[/yellow][green]a[/green][blue]human[/blue][#6600FF]friendly[/#6600FF][magenta]way[/magenta]
         """
```

## Beauty Of Spectra
``` nim
#This example is to express how spectra can be used for ascii arts

# Create gradient-like effects with multiple colors
<<<<<<< HEAD
#to recreate the uniocde block below
=======
#to recreate the unicode block below
>>>>>>> fadb77f (Revised color and style syntax)
#for linux, enter "Ctrl + Shift + u" and then type "2592" and press enter
paint("""
[#FF0000]▓▓▓[/#FF0000][#FF3300]▓▓▓[/#FF3300][#FF6600]▓▓▓[/#FF6600][#FF9900]▓▓▓[/#FF9900][#FFCC00]▓▓▓[/#FFCC00]
[#CC0000]▓▓▓[/#CC0000][#CC3300]▓▓▓[/#CC3300][#CC6600]▓▓▓[/#CC6600][#CC9900]▓▓▓[/#CC9900][#CCCC00]▓▓▓[/#CCCC00]
[#990000]▓▓▓[/#990000][#993300]▓▓▓[/#993300][#996600]▓▓▓[/#996600][#999900]▓▓▓[/#999900][#99CC00]▓▓▓[/#99CC00]
""")

# Simple colored blocks and patterns
#to recreate the unicode block below
#for linux, enter "Ctrl + Shift + u" and then type "2588" and press enter
paint("""
[red]████████[/red][green]████████[/green][blue]████████[/blue]
[red]████████[/red][green]████████[/green][blue]████████[/blue]
[yellow]████████[/yellow][magenta]████████[/magenta][cyan]████████[/cyan]
""")

paint("""
[red]R[/red][#FF6600]A[/#FF6600][yellow]I[/yellow][green]N[/green][blue]B[/blue][#6600FF]O[/#6600FF][magenta]W[/magenta]

[red]▄▄▄▄▄[/red][#FF6600]▄▄▄▄▄[/#FF6600][yellow]▄▄▄▄▄[/yellow][green]▄▄▄▄▄[/green][blue]▄▄▄▄▄[/blue][#6600FF]▄▄▄▄▄[/#6600FF][magenta]▄▄▄▄▄[/magenta]
""")


#ctrl+ shift+u + 250c = ┌
#ctrl+ shift+u + 2514 = └
#ctrl+ shift+u + 2518 = ┘
#ctrl+ shift+u + 2510 = ┐
#ctrl+ shift+u + 2500 = ─
#ctrl+ shift+u + 2502 = │
paint "[c=255 bg=24]┌────────────────────┐[reset]"
paint "[c=255 bg=24]│     Submit         │[reset]"
paint "[c=255 bg=24]└────────────────────┘[reset]"
```

## Results
![beauty](/example_result/beauty.png)


