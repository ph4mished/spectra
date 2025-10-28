import ../src/spectra

#This example is to express how huewheel can be used for ascii arts

# Create gradient-like effects with multiple colors
#to recreate the unicde block below
#for linux, enter "Ctrl + Shift + u" and then type "2592" and press enter
echo "\n\n\n\n\n"
paint("""
                            [fg=#FF0000]▓▓▓[fg=#FF3300]▓▓▓[fg=#FF6600]▓▓▓[fg=#FF9900]▓▓▓[fg=#FFCC00]▓▓▓[reset]
                            [fg=#CC0000]▓▓▓[fg=#CC3300]▓▓▓[fg=#CC6600]▓▓▓[fg=#CC9900]▓▓▓[fg=#CCCC00]▓▓▓[reset]
                            [fg=#990000]▓▓▓[fg=#993300]▓▓▓[fg=#996600]▓▓▓[fg=#999900]▓▓▓[fg=#99CC00]▓▓▓[reset]
""")

# Simple colored blocks and patterns
#to recreate the unicde block below
#for linux, enter "Ctrl + Shift + u" and then type "2588" and press enter
paint("""
                       [fg=red]████████[fg=green]████████[fg=blue]████████[reset]
                       [fg=red]████████[fg=green]████████[fg=blue]████████[reset]
                       [fg=yellow]████████[fg=magenta]████████[fg=cyan]████████[reset]
""")



# Colored cat face
paint("""
[bold=reset fg=yellow]   /\\_/\\  
  ( o.o ) 
   > ^ <
[bold=reset fg=yellow]
[fg=white] 
   /\\_/\\  
  ( -.- ) 
   > ^ <
[reset]
""")



#Arrow
paint("""
[fg=green]     *
    ***
   *****
  *******
 *********
[fg=red]    ***
    ***
    ***
[reset]
""")



#Rocket
paint("""
[fg=white]     /\\
    /  \\
   /____\\
[fg=red]   |    |
   |    |
[fg=blue]  /|    |\\
 / |    | \\
[fg=yellow]*  [fg=red]/\\  /\\[reset]  *
[reset]
""")



paint("""
[fg=yellow]  -----
 | o o |
 |  ^  |
 | \\_/ |
  -----
[reset]

[fg=cyan]  -----
 | • • |
 |  ▽  |
 | ___ |
  -----
[reset]
""")



paint("""
                  [bold fg=red]▄▄▄▄▄[fg=#FF6600]▄▄▄▄▄[fg=yellow]▄▄▄▄▄[fg=green]▄▄▄▄▄[fg=reset][fg=blue]▄▄▄▄▄[fg=#6600FF]▄▄▄▄▄[fg=magenta]▄▄▄▄▄[reset]
""")





paint("""
[bold fg=yellow]    *       *       *
       *       *    
  *         *        *
     *           *
        *     *
[fg=yellow]    *       *       *
[reset]
""")



paint("""
[fg=magenta]  .     .     .
   \\___/ \\___/
  /\\___/\\___/\\
  \\/___\\/___\\/
[fg=blue]  .     .     .
[reset]
""")

#ctrl+ shift+u + 250c = ┌
#ctrl+ shift+u + 2514 = └
#ctrl+ shift+u + 2518 = ┘
#ctrl+ shift+u + 2510 = ┐
#ctrl+ shift+u + 2500 = ─
#ctrl+ shift+u + 2502 = │
paint "                        [fg=255 bg=24]┌────────────────────┐[reset]"
paint "                        [fg=255 bg=24]│     Submit         │[reset]"
paint "                        [fg=255 bg=24]└────────────────────┘[reset]"



