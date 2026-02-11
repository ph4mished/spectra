import ../src/spectra

# Simple colored text
parse("[fg=green]Success message![reset]").apply()
parse("[fg=red bold]Error: Something went wrong![reset]").apply()
parse("[fg=cyan italic]Info message[reset]").apply()

# Background colors
parse("[bg=blue fg=white]White text on blue background[reset]").apply()
parse("[bg=lightgreen fg=black]Black text on light green[reset]").apply()

# Hex colors (requires truecolor support)
parse("[fg=#FF5733]Orange hex color[reset]").apply()
parse("[bg=#3498db]Blue background[reset]").apply()

# RGB colors
parse("[fg=rgb(255,105,180)]Hot pink text[reset]").apply()
parse("[bg=rgb(50,205,50)]Lime green background[reset]").apply()

# 256-color palette
parse("[fg=214]Orange from 256-color palette[reset]").apply()
parse("[bg=196]Red background from palette[reset]").apply()

