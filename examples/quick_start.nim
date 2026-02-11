
import strformat, ../src/spectra


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
