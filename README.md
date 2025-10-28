# Spectra

**Spectra** is a library for text coloring and formatting.

# Installation
``` nim
nimble install huewheel
```

# Features
1. **Smart Parsing** - Spectra knows the difference between text and color tags. No accidental parsing of [ERROR], [INFO]  or other square bracket bounded words as colors.
2. It also supports granular resets, Only what you close resets (foreground, background, or text styles) as well as one-for-all reset (reset).
3. Support for multiple color systems {basic ANSI colors, hex colors and 256-color Palette}.

# Weakness
At the moment, spectra lacks windows and mac os support, hence its not cross-platform(only native to linux).

# Usage
Spectra supports more than one color tags in its square brackets bounded tags.

# Importing the package
``` nim
import huewheel
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
import terminal
#colorEnabled is the global switch for huewheel color
colorEnabled = stdout.isatty()

paint "[red]ERROR[/red]"
#prints only "ERROR" without color when its redirected to file or to another tool.

#color on
colorEnabled = true
paint "[green]Development Mode[reset]"

#color off
colorEnabled = false
paint "[green]Sorry, I can't be colored[/green]"

#respect for no color
colorEnabled= not paramStr(1) == "--no-color"
paint("[green]Ready[/green]")
```

## Per-Call (global toggle override)
``` nim
#Force color (override global setting)
#enabledColor will be called for global setting
enabledColor = false

#colorToggle is used for per call control or to override enabledColor control
paint("[bold italic yellow]WARNING[reset]")

paint("[red]ALWAYS RED[/red]", colorToggle=true)

paint("[blue]COLOR DEPENDS[/blue]", colorToggle=stdout.isatty())
```

# Smart Bracket Handling
``` nim
paint "[cyan][[magenta]OPTIONS[/magenta][cyan]]
```

# HueWheel In Action
``` nim
paint """[bold magenta]HueWheel[/bold]
         brings [cyan]colors[/cyan] to life!
         [red]And[/red][#FF6600]also[/#FF6600][yellow]in[/yellow][green]a[/green][blue]human[/blue][#6600FF]friendly[/#6600FF][magenta]way[/magenta]
         """
```

## Beauty Of HueWheel
``` nim
#This example is to express how huewheel can be used for ascii arts

# Create gradient-like effects with multiple colors
#to recreate the uniocde block below
#for linux, enter "Ctrl + Shift + u" and then type "2592" and press enter
paint("""
[#FF0000]▓▓▓[/#FF0000][#FF3300]▓▓▓[/#FF3300][#FF6600]▓▓▓[/#FF6600][#FF9900]▓▓▓[/#FF9900][#FFCC00]▓▓▓[/#FFCC00]
[#CC0000]▓▓▓[/#CC0000][#CC3300]▓▓▓[/#CC3300][#CC6600]▓▓▓[/#CC6600][#CC9900]▓▓▓[/#CC9900][#CCCC00]▓▓▓[/#CCCC00]
[#990000]▓▓▓[/#990000][#993300]▓▓▓[/#993300][#996600]▓▓▓[/#996600][#999900]▓▓▓[/#999900][#99CC00]▓▓▓[/#99CC00]
""")

# Simple colored blocks and patterns
#to recreate the unicde block below
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


