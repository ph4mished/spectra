import os, ../src/spectra


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
