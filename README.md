# Spectra

**Spectra** is a high performance library for terminal text coloring and formatting.

# Installation

```bash
nimble install spectra
```

# Features

- Multiple Color Systems: Named colors, hex codes, RGB, 256-color palette
- TrueColor Detection: Automatic detection of terminal truecolor support
- Terminal Safe: Graceful fallbacks when color not supported(no-color fallback)
- Simple API: Easy-to-use functions for text styling and coloring.
- Comprehensive Styles: Bold, italic, underline, blink, reverse, hidden, strike-through
- Granular Resets: Individual and full reset codes for precise control
- No Escape: Texts in [] that aren't colors/styles are left as it is.

# Core Concepts

## Template System

The library follows a template-first approach: parse color templates once with or without placeholders([0], [1], etc), then reuse them with different data to replace placeholders.
**Placeholders are like slots**

## Color Toggling

Respects the NO_COLOR environment variable and detects when output is redirected. It can be manually controlled to suit user preference.

---

# Quick Start

```nim

import strformat, spectra


# Parse and use color codes directly
let red = parseColor("fg=red")
let bold = parseColor("bold")
let reset = parseColor("reset")
    
echo fmt"{red}{bold}This is red and bold!{reset}"

# Check if a color is supported
if isSupportedColor("fg=#FF0000"):
  echo "Hex colors are supported!"
  
    
# Or use the main functions
parse("[fg=blue]Hello in blue![reset]").apply()
parse("[bg=yellow fg=black bold]Bold black text on yellow background.[reset]").apply()


# Or pre-parse the color template with placeholders for reuse. 
# This is the heart of the library's performance.

# Parse once
let temp = parse("[fg=red bold]Error: [0][reset]")

# Reuse multiple times
echo temp.apply("File not found")
echo temp.apply("Permission denied")
echo temp.apply("Network timeout")


```

# Complete Usage Examples

## Basic Template with Placeholders

```nim
import strformat, ../src/spectra


# Simple template with one placeholder
let greeting = parse("[fg=green]Hello, [0][reset]!")
    
echo greeting.apply("Alice")
echo greeting.apply("Bob")
echo greeting.apply("World")
    
# Complex template with multiple placeholders
let logTemplate = parse("[0] [fg=blue][1][reset]: [fg=yellow][2][reset]")
    
# Different log levels
echo logTemplate.apply("[INFO]", "main", "Application started")
echo logTemplate.apply("[WARN]", "auth", "Token expiring soon")
echo logTemplate.apply("[ERROR]", "db", "Connection failed")

```

## Basic Text Coloring
```nim
import spectra

# Simple colored text
parse("[fg=green]Success message![reset]").apply()
parse("[fg=red bold]Error: Something went wrong![reset]").apply()
parse("[fg=cyan italic]Info message[reset]").apply()

# Background colors
parse("[bg=blue fg=white]White text on blue background[reset]").apply()
parse("[bg=lightgreen fg=black]Black text on light green[reset]").apply()

```

## Advanced Color Formats

```nim
import spectra

# Hex colors (requires truecolor support)
parse("[fg=#FF5733]Orange hex color[reset]").apply()
parse("[bg=#3498db]Blue background[reset]").apply()

# RGB colors
parse("[fg=rgb(255,105,180)]Hot pink text[reset]").apply()
parse("[bg=rgb(50,205,50)]Lime green background[reset]").apply()

# 256-color palette
parse("[fg=214]Orange from 256-color palette[reset]").apply()
parse("[bg=196]Red background from palette[reset]").apply()

```

## Text Styles

```nim
import spectra

# Combine styles
parse("[bold underline=single] Bold and underlined[reset]").apply()
parse("[italic dim]", "Dim italic text. [italic=reset dim=reset][strike]Strikethrough  text only[reset]").apply()
parse("[blink=slow hidden]Slow blinking hidden text[reset]").apply()

# Reset specific attributes
parse("[bold fg=blue]Blue bold text. [bold=reset]No longer bold, but still blue. [fg=reset]No color, but other styles remain[reset]").apply()

```

## Color Toggling

```nim
import os, spectra


# Create color toggle - respects NO_COLOR env var and when output is redirected by default
let toggle = color.newColorToggle()
    
# Parse templates using the toggle
let successTemplate = toggle.parse("[fg=green]✓ [0][reset]")
let errorTemplate = toggle.parse("[fg=red]✗ [0][reset]")
    
# These will only show colors if appropriate
echo successTemplate.apply("Operation completed")
echo errorTemplate.apply("Operation failed")
    
# Manual control
let forceColors = color.newColorToggle(true)   # Always show colors
let noColors = color.newColorToggle(false)     # Never show colors
    
# Use in CLI applications
let useColor = getEnv("NO_COLOR") == ""
let appToggle = color.newColorToggle(useColor)
    
let helpTemplate = appToggle.parse("[bold fg=cyan][0][reset] [fg=green][1][reset]")
echo helpTemplate.apply("Usage:", "myapp [options]")

```

## Advanced Template Examples

```nim
import os, strformat, spectra

# Status indicator with conditional colors
let statusTemplate = parse("[0] : [1][reset]")

type Item* = object
  name*: string
  status*: string
   
var 
  items: seq[Item]
  statusColor: string

items.add(Item(name: "Database", status: "Online"))
items.add(Item(name: "API Server", status: "Offline"))
items.add(Item(name: "Cache", status: "Degraded"))

for item in items:
  case item.status:
  of "Online":
    statusColor = "[fg=green bold]"
  of "Offline":
    statusColor = "[fg=red bold]"
  else:
    statusColor = "[fg=yellow]"
    
  let statusColored = parse(statusColor & item.status).apply()
  echo statusTemplate.apply(item.name, statusColored)
    
# Progress bar template
let progressTemplate = parse("[fg=cyan][0][reset]/[fg=cyan][1][reset] [fg=green][2][reset]%")
    
let total = 100
for i in 0..total:
  let percent = i * 100 / total
  stdout.write("\r" & progressTemplate.apply($i, $total, $percent))
  stdout.flushFile()
  sleep(100)
echo "\n"

```

## Building Complex UIs

```nim
import strutils, spectra
    
# Table with colored headers
let headerTemplate = parse("[bold fg=cyan][0][reset]")
let rowTemplate = parse("[0]  [fg=yellow][1][reset]  [fg=green][2][reset]")
    
echo headerTemplate.apply("─".repeat(40))
echo headerTemplate.apply("USER MANAGEMENT")
echo headerTemplate.apply("─".repeat(40))
    
echo rowTemplate.apply("Alice", "admin", "active")
echo rowTemplate.apply("Bob", "user", "active")
echo rowTemplate.apply("Charlie", "guest", "inactive")
    
# Nested templates
let errorTemplate = parse("[bold fg=red][0][reset]: [1]")
let suggestionTemplate = parse("[fg=yellow]Suggestion: [0][reset]")
 
 
type Err = object
  code: string
  msg: string
  suggestion: string
  

var errors: seq[Err]
errors.add(Err(code: "E001", msg: "File not found", suggestion: "Check the file path"))
errors.add(Err(code: "E002", msg: "Permission denied", suggestion: "Run with sudo or check permissions"))
errors.add(Err(code: "E003", msg: "Out of memory", suggestion: "Close other applications"))

for err in errors:
  echo errorTemplate.apply(err.code, err.msg)
  echo "  " & suggestionTemplate.apply(err.suggestion)
  echo "\n" 

```

## Project Structure Example

```nim
# file: styles.nim - Define your color scheme

import spectra, terminal

let toggle = newColorToggle(not noColor and stdout.isatty())

let help* = (
  header: toggle.parse( "[bold fg=cyan][0][reset]"),
  description: toggle.parse("[bold fg=magenta][0][reset]"),
  section: toggle.parse("\n[bold fg=blue][[fg=cyan][0][fg=blue]][reset]\n"),
  flag: toggle.parse("\t[bold fg=#FF6600][0][fg=green], [fg=#FF6600][1] [fg=green]: [2][reset]")
)
```



```nim
include styles

# file: help.nim - Use the color templates

import strutils, strformat


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


```nim
import help

# file: main.nim - Main application
echo helpFunc()
```


## CLI Applications

```nim
import os, spectra

# Best practice for CLI applications

# Check for --no-color flag

let noColorFlag: bool = false

for arg in commandLineParams():
  if arg == "--no-color":
    noColorFlag = true
    break
    
# Respect both flag and environment variable
let useColor = !noColorFlag and getEnv("NO_COLOR") == ""
    
# Create toggle
let toggle = color.newColorToggle(useColor)
    
# All templates use this toggle
    templates := struct {
        Success color.CompiledTemplate
        Error   color.CompiledTemplate
        Header  color.CompiledTemplate
    }{
        Success: toggle.parse("[fg=green]✓ [0][reset]"),
        Error:   toggle.parse("[fg=red]✗ [0][reset]"),
        Header:  toggle.parse("[bold][0][reset]"),
    }
    
# Use templates - they'll respect the toggle
echo templates.header.apply("My Application"))
echo templates.success.apply("Started successfully"))
    
# If --no-color was used or NO_COLOR is set,
# outputs will be plain text without escape codes
}
```

## Error Handling in Templates

```nim
import ../src/spectra, tables

# Template for showing validation errors
let validationTemplate = parse("[fg=red]• [0]: [1][reset]")
    
let errors = {
  "username": "Must be at least 3 characters",
  "email":    "Invalid email format",
  "password": "Must contain uppercase and numbers"
}.toTable
    
echo parse("[bold fg=yellow]Validation Errors:[reset]").apply()
for field, message in errors:
  echo validationTemplate.apply(field, message)


# Template with conditional formatting
let scoreTemplate = parse("[0]: [1]")
 
type Score = object
  name: string
  score: int
 
var scores: seq[Score]

scores.add(Score(name: "Alice", score: 95))
scores.add(Score(name: "Bob", score: 75))
scores.add(Score(name: "Charlie", score: 45))
scores.add(Score(name: "Diana", score: 60))

   
for s in scores:
  var scoreColor: string
  if s.score >= 90:
    scoreColor = "[fg=green bold]"
  elif s.score >= 70:
    scoreColor = "[fg=yellow]"
  else:
    scoreColor = "[fg=red]"
  let coloredScore = parse(scoreColor & $s.score & "[reset]").apply()
  echo scoreTemplate.apply(s.name, coloredScore)

```

## Pattern to avoid
```nim
# Good pattern

proc init() =
  let toggle = color.newColorToggle()
  let success = toggle.parse("[fg=green] [0][reset]")
  let error = toggle.parse("[fg=red] [0][reset]")


# Bad pattern (parsing in hot loop)

proc processItems(items: seq[string]) =
  for item in items:
    # DON'T DO THIS - parses every iteration!
    let tmpl = parse("[fg=blue]" & item & "[reset]")
    echo tmpl.apply())

```

## Performance Comparison

```nim
import times, strformat, spectra



const iterations = 1000000
    
# Method 1: parse once, apply many
let temp = parse("[bold fg=red][0][reset] [fg=green][1][reset]")
    
var start = cpuTime()
for i in 0..iterations:
  temp.apply(fmt "Item{i}", "Value{i}")

echo fmt "Template reuse: {cpuTime() - start}"

    
# Method 2: parse every time
start = cpuTime()
for i in 0..iterations:
  parse(fmt"[bold fg=red]Item{i}[reset] [fg=green]Value{i}[reset]").apply()

echo fmt "Parse every time: {cpuTime() - start}"

    
# Method 3: Manual concatenation
start = cpuTime()
for i in 0..iterations:
  let parseCol = parseColor("fg=red bold") & fmt"Item{i}" & parseColor("reset") & " " & parseColor("fg=green") & fmt"Value{i}" & parseColor("reset")

echo fmt "Manual concatenation: {cpuTime() - start}"

```

## Performance Comparison Result

```bash
Template reuse: 5.38109636
Parse every time: 48.491620272999995
Manual concatenation: 20.403113159999997

```


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
| `underline=single` | Single underlined text |
| `underline=double` | Double underlined text |
| `blink=slow` | Slow blinking text |
| `blink=fast` | Fast blinking text |
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



# Tips and Best Practices

1. Parse Once: Always parse templates at initialization, not in loops
2. Use Toggles: Respect user preferences with color toggling
3. Template Reuse: Create templates for consistent styling
4. Placeholder Limits: The current implementation supports [0] through [999]
5. Testing: Test both color and no-color outputs


# Limitations

1. Terminal Dependency: Colors only work in terminals that support ANSI escape codes(Unix/Linux platform)
2. TrueColor Requirement: Hex and RGB colors require terminal with truecolor support
3. Style Support: Some styles (blink, double underline) may not work in all terminals
4. Color Detection: Fallback from truecolor to 256-color not yet implemented
5. Windows: May require additional setup on Windows terminals

# Platform Support

- Linux/macOS terminals (full support)
- Windows Terminal/WSL (good support probably)
- Legacy Windows CMD (not supported)
- iTerm2, GNOME Terminal, Kitty (not tested yet)

# Contributing

We welcome contributions! Here's how you can help:

1. Report Bugs: Open an issue with reproduction steps
2. Suggest Features: Share your ideas for improvements
3. Submit PRs:
   - Fork the repository
   - Create a feature branch
   - Add tests for your changes
   - Ensure code follows Nim conventions
   - Submit a pull request


# Development Setup

```bash
# Clone the repository
git clone https://github.com/ph4mished/spectra.git
cd spectra

# Run tests
cd tests
nim c -r test1.ni && nim c -r test2

```

# Areas Needing Improvement

1. Better Windows compatibility
2. 256-color fallback for truecolor
3. Performance optimization

# License

MIT License - see LICENSE file for details.

# Acknowledgments

- ANSI escape code specifications
- The Nim community for testing and feedback
- All contributors who have helped improve this library

---

**Note**: Always test color output in different terminals to ensure compatibility with your users' environments. Consider providing a --no-color flag in your applications for users who prefer plain text.

# color
Spectra has a port in Golang called [color](https://www.github.com/ph4mished/color)


