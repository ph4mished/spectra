# Spectra

**Spectra** is a high performance library for terminal text coloring and formatting.

# Installation
``` nim
nimble install spectra
```

# Features
- It supports granular resets, Only what you close resets (foreground, background, or text styles) as well as one-for-all reset (reset).
- Support for multiple color systems {basic ANSI colors, hex colors and 256-color Palette}.
- Spectra uses [ ]-enclosed syntax but its not an owned syntax. **Users are free to use "[ ]" for anything of their choice without needing escapes, only if its content does not count as spectra tag/color.**
 
**Spectra has true color support**, depending on your terminal's true color support. This is achieved through its hex and RGB colors.

When true-color is not available, **hex and RGB colors will not be rendered**

# Limitation
Spectra supports Unix-like systems including Linux and macOS. Windows is not supported due to different terminal architecture.


# Usage
**Spectra supports more than one color tags in its square brackets bounded syntax (but one bad nut spoils all).** 

It means spectra accepts this 
``` nim
echo parse("[fg=white][bold italic strike fg=cyan]Hello World[reset]").apply()
#This will work perfectly 
```
**but a typo goes unforgiven**
```nim
echo parse("[fg=white][bld italic strike fg=cyan]Hello World[reset]").apply()

#"bld" is the bad nut, so all other tags enclosed in same [] are treated as literals.
#hence it prints "[bld italic strike fg=cyan]Hello World" colored white due to the first color (fg=white). 

#Because the tool sees it as an escape, not a typo
```

# Importing the package
``` nim
import spectra
```

# Precompilation or Precomputation:
Spectra is **color template-first**. 

Reasons template-first coloring is preferred:
- DRY Principle (Define once, use anywhere)
- Pay parsing overhead cost once by precompiling (Performance boost)


Worried about **manual interpolation or string concatenation**??
Just use **indices (square bracket bounded numbers)**. See the example below.
``` nim
let test = parse("[bold fg=red]Hello [0][fg=cyan blink][1][reset]")
                                      ^                 ^             
                                      |                 |
                                      Indices/Placeholders 0 and 1 are slots awaiting dynamic input from apply()  


for i in 0..1000000:
  echo test.apply("world", $i)

#[0] and [1] are positional indices(index), which are used by "apply()" for interpolation.
#Based on the parameters of apply(), [0]  ==> "world" and [1] ==> i
```



## Usage Examples
```nim
import spectra

#Multiple styles in one tag
echo parse("[bold italic fg=red]Important![reset]").apply()


#Granular reset control
echo parse("[bold fg=red bg=blue]Alert[bold=reset] Still colored[fg=reset bg=reset] Normal").apply()


#Hex colors
echo parse("[fg=#FF0000]Red text[fg=#00FF00]Green text[reset]").apply()

#RGB colors
echo parse("[fg=rgb(255,0,0)]Red text[fg=rgb(0,255,0)]Green text[reset]").apply()


#256 colors
echo parse("[fg=202]Orange text[fg=45]Blue text[reset]").apply()

#Spectra for other languages through interpolation. Express Precompilation flexibility
let lang_temp = parse("[fg=red][0]: [fg=green][1][reset]")

echo lang_temp.apply("Error", "File not found") #English
echo lang_temp.apply("Erreur", "Fichier non trouve") #French


#Define once, use anywhere
let help_temp = parse("[bold fg=cyan][0][fg=green], [fg=cyan][1][bold=reset fg=green]: [fg=yellow][2][reset]")

echo help_temp.apply("-h", "--help", "Show help and exit")
echo help_temp.apply("-v", "--version", "Show version")
echo help_temp.apply("-r", "--recursive", "Run recursively")

```


# Coloring a text
``` nim
echo parse("[bold][fg=yellow]Hello Word[reset]").apply() 

echo parse("[bold fg=red]Error:[bold=reset] File not found[reset]").apply()

#hex color
echo parse("[fg=#FF0000 underline]DANGER[fg=reset underline=reset]").apply()

# 256 color support
let btnTemplate  = parse("[fg=255 bg=24][0][reset]")

echo btnTemplate.apply("┌────────────────────┐")
echo btnTemplate.apply("│       Submit       │")
echo btnTemplate.apply("└────────────────────┘")

```

# Escapes
``` nim
#Normally no escapes are required if contents in "[ ]" are not colors or styles
#For escape when contents are colors or styles, use apply()

#EXAMPLE
echo parse("[fg=green bold]Hey Fred, be [0] and [1] hard[reset]").apply("[bold]", "[strike]") #Safe for escapes too
```

# Color Toggling
``` nim

#default color toggling
# automatically switches off color when output is redirected or when terminal has NO_COLOR on
newColorToggle()


newColorToggle(true) #Color always stays on
newColorToggle(false) #Color always off


#EXAMPLES
let toggle = newColorToggle()

let help_temp = toggle.parse("[bold fg=cyan][0][fg=green], [fg=cyan][1][bold=reset fg=green]: [fg=yellow][2][reset]")

echo help_temp.apply("-h", "--help", "Show help and exit")
echo help_temp.apply("-v", "--version", "Show version")
echo help_temp.apply("-r", "--recursive", "Run recursively")

#OR
## IMPLICIT newColorToggle() CALL
##================================
#still works without explicitly calling colorToggle
#newColorToggle() is implicitly called by "parse()" 
#when used implicitly, each "parse()" call creates a newColorToggle()
let help_temp = parse("[bold fg=cyan][0][fg=green], [fg=cyan][1][bold=reset fg=green]: [fg=yellow][2]")
let test_temp = parse("[bold fg=green]Test Me[reset]")

#both test_temp and help_temp create newColorToggle() implicitly but they do not share. Each call creates its own

echo help_temp.apply("-h", "--help", "Show help and exit")
echo help_temp.apply("-v", "--version", "Show version")
echo help_temp.apply("-r", "--recursive", "Run recursively")




#respect for no-color flag
let no_color = newColorToggle(not paramStr(1) == "--no-color")
echo parse(no_color, "[fg=green]Ready[reset]").apply()
```


# Spectra In Action
``` nim
#EXAMPLE ONE
let itemTemp = parse("[0], [fg=cyan][1][reset]")

let fruits = @["Apple", "Watermelon", "Grapes", "Banana"]
for i, fruit in fruits:
  echo itemTemp.apply($(i+1), fruit)


#EXAMPLE TWO
let temp_template = parse("Temperature: [0]")

proc showTemp(temp: int) =
  let color = if temp > 25: "[fg=red]" elif temp < 10: "[fg=blue]" else: "[fg=green]"
  let comp = parse(color & "[0]°C[reset]")
  echo temp_template.apply(comp.apply($temp))

showTemp(25)
showTemp(14)
showTemp(4)

#EXAMPLE THREE
let loginTemp = parse("""
Username: [fg=cyan][0][reset]
Password: [fg=yellow][1][reset]
""")

echo loginTemp.apply("Jay Pal", "********")
```
## For Projects
### Style File (Define spectra colors upfront)
```nim
 # styles.nim
 import spectra, terminal

let toggle = newColorToggle(not noColor and stdout.isatty())

let help* = (
  header: toggle.parse( "[bold fg=cyan][0][reset]"),
  description: toggle.parse("[bold fg=magenta][0][reset]"),
  section: toggle.parse("\n[bold fg=blue][[fg=cyan][0][fg=blue]][reset]\n"),
  flag: toggle.parse("\t[bold fg=#FF6600][0][fg=green], [fg=#FF6600][1] [fg=green]: [2][reset]")
)
```

### Help File (Applying defined colors)
```nim
# help.nim
import strutils, strformat
include styles


proc helpFunc*() =
  echo help.description.apply(" cp - copy files and directories.")
  echo help.description.apply("Copy SOURCE to DEST, or multiple SOURCE(s) to DIRECTORY.")
  
  echo help.header.apply("\nUsage: cp [OPTIONS] SOURCE DEST")
  
  echo help.section.apply("OPTIONS")
  echo help.flag.apply("-h", "--help", "display this help and exit")
  echo help.flag.apply("-v", "--version", "output version information and exit")
  echo help.flag.apply("", "--verbose", "explain what is being done")
  echo help.flag.apply("-l", "--link", "hard link files instead of copying")
```



## Beauty Of Spectra
``` nim
#This example is to express how spectra can be used for ascii arts

# Create gradient-like effects with multiple colors
#to recreate the unicode block below
#for linux, enter "Ctrl + Shift + u" and then type "2592" and press enter
echo parse("""
[fg=#FF0000][0][fg=#FF3300][0][fg=#FF6600][0][fg=#FF9900][0][fg=#FFCC00][0][reset]
[fg=#CC0000][0][fg=#CC3300][0][fg=#CC6600][0][fg=#CC9900][0][fg=#CCCC00][0][reset]
[fg=#990000][0][fg=#993300][0][fg=#996600][0][fg=#999900][0][fg=#99CC00][0][reset]
""").apply("▓".repeat(3))



# Simple colored blocks and patterns
#to recreate the unicode block below
#for linux, enter "Ctrl + Shift + u" and then type "2588" and press enter

let blkTemp = parse("[fg=red][0][fg=green][0][fg=blue][0][reset]")
let lastTemp = parse("[fg=yellow][0][fg=magenta][0][fg=cyan][0][reset]\n")

echo blkTemp.apply("█".repeat(8))
echo blkTemp.apply("█".repeat(8))
echo lastTemp.apply("█".repeat(8))



echo parse("""
[fg=red][0][fg=#FF6600][0][fg=yellow][0][fg=green][0][fg=blue][0][fg=#6600FF][0][fg=magenta][0][reset]
""").apply("▄".repeat(5))


#ctrl+ shift+u + 250c = ┌
#ctrl+ shift+u + 2514 = └
#ctrl+ shift+u + 2518 = ┘
#ctrl+ shift+u + 2510 = ┐
#ctrl+ shift+u + 2500 = ─
#ctrl+ shift+u + 2502 = │

let btnTemplate = parse("[fg=255 bg=24][0][1][2][reset]")

echo btnTemplate.apply("┌", "─".repeat(12), "┐")
echo btnTemplate.apply("│", "   Submit   ", "│")
echo btnTemplate.apply("└", "─".repeat(12), "┘")
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
| `fg=rgb(RR,GG,BB)` |RGB color for foreground |
| `bg=rgb(RR,GG,BB)` | RGB color for background |
| `fg=NNN` | 256-color palette (0-255) for foreground |
| `bg=NNN` | 256-color palette (0-255) for background |


# Parsing Overhead Benchmark
I decided to test the speed of spectra parsing.
``` nim
import spectra, strformat, times


let iterations = 1000000

#for spectra with precomputation
let comp = parse("[bold fg=cyan italic] Processing [fg=yellow underline][0][fg=green strike] from [dim blinkfast   fg=#FFFFFF] file 1 [reverse fg=254]to end[reset]")

let fStartTime = cpuTime()
for i in 0..iterations:
  discard comp.apply($i)
let fEndTime = cpuTime()

#for spectra without precomputation (simulating naive color libraries)
#Reparse per loop
let sStartTime = cpuTime()
for i in 0..iterations:
  discard parse("[bold fg=cyan italic] Processing [fg=yellow underline][0][fg=green strike] from [dim blinkfast fg=#FFFFFF] file 1 [reverse fg=254]to end[reset]").apply($i)
let sEndTime = cpuTime()

#Checking without spectra
let tStartTime = cpuTime()
for i in 0..iterations:
  discard fmt "Processing {i} from file 1  to end."
let tEndTime = cpuTime()




echo "First Loop Duration [Spectra]: ", fEndTime-fStartTime, "sec"
echo "Second Loop Duration [Parse Per Loop]: ", sEndTime-sStartTime, " sec"
echo "Third Loop Duration [Pure Nim]: ", tEndTime-tStartTime, " sec"

```

## Output
``` bash
First Loop Duration [Spectra]: 3.048232739sec
Second Loop Duration [Parse Per Loop]: 163.822929514 sec
Third Loop Duration [Pure Nim]: 1.254006722999975 sec

```
## Note
**The benchmark is to show how low spectra interpolation overhead is and how effiecient it is in loops.**

**By default spectra is more than 48x faster than most naive color libraries for hot loops (all thanks to precomputation)**

**Test for yourself if you doubt this benchmark**


# Contributing

You can help improve Spectra by:

- Trying to use it and giving feedback
- Test the programs under different MacOS versions or Linux distributions
- Help improving and extending the code
- Adding Windows support


# SPECTRA CREED
We believe terminal coloring should be **predictable, fast** and **explicit**. We optimize for productiona performance over development convenience, and for runtime efficiency over typo forgiveness. Our users value speed and reliability over 
