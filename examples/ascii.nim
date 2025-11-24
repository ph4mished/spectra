import ../src/spectra, strutils

#This example is to express how huewheel can be used for ascii arts

# Create gradient-like effects with multiple colors
#to recreate the unicde block below
#for linux, enter "Ctrl + Shift + u" and then type "2592" and press enter
echo "\n\n\n\n\n"
echo parse("""
[fg=#FF0000][0][fg=#FF3300][0][fg=#FF6600][0][fg=#FF9900][0][fg=#FFCC00][0][reset]
[fg=#CC0000][0][fg=#CC3300][0][fg=#CC6600][0][fg=#CC9900][0][fg=#CCCC00][0][reset]
[fg=#990000][0][fg=#993300][0][fg=#996600][0][fg=#999900][0][fg=#99CC00][0][reset]
""").apply("▓".repeat(3))



# Simple colored blocks and patterns
#to recreate the unicde block below
#for linux, enter "Ctrl + Shift + u" and then type "2588" and press enter
let blkTemp = parse("[fg=red][0][fg=green][0][fg=blue][0][reset]")
let lastTemp = parse("[fg=yellow][0][fg=magenta][0][fg=cyan][0][reset]\n")

echo blkTemp.apply("█".repeat(8))
echo blkTemp.apply("█".repeat(8))
echo lastTemp.apply("█".repeat(8))




# Colored cat face
echo parse("""
[bold=reset fg=yellow]   /\\_/\\  
  ( o.o ) 
   > ^ <
[bold=reset fg=yellow]
[fg=white] 
   /\\_/\\  
  ( -.- ) 
   > ^ <
[reset]
""").apply()



#Arrow
echo parse("""
[fg=green]     *
    ***
   *****
  *******
 *********
[fg=red]    ***
    ***
    ***
[reset]
""").apply()



#Rocket
echo parse("""
[fg=white]     /\\
    /  \\
   /____\\
[fg=red]   |    |
   |    |
[fg=blue]  /|    |\\
 / |    | \\
[fg=yellow]*  [fg=red]/\\  /\\[reset]  *
[reset]
""").apply()



echo parse("""
[fg=yellow]  -----
 | o o |
 |  ^  |
 | \_/ |
  -----
[reset]

[fg=cyan]  -----
 | • • |
 |  ▽  |
 | ___ |
  -----
[reset]
""").apply()



echo parse("""
[fg=red][0][fg=#FF6600][0][fg=yellow][0][fg=green][0][fg=blue][0][fg=#6600FF][0][fg=magenta][0][reset]
""").apply("▄".repeat(5))





echo parse("""
[bold fg=yellow]    *       *       *
       *       *    
  *         *        *
     *           *
        *     *
[fg=yellow]    *       *       *
[reset]
""").apply()



echo parse("""
[fg=magenta]  .     .     .
   \\___/ \\___/
  /\\___/\\___/\\
  \\/___\\/___\\/
[fg=blue]  .     .     .
[reset]
""").apply()

#ctrl+ shift+u + 250c = ┌
#ctrl+ shift+u + 2514 = └
#ctrl+ shift+u + 2518 = ┘
#ctrl+ shift+u + 2510 = ┐
#ctrl+ shift+u + 2500 = ─
#ctrl+ shift+u + 2502 = │
let btnTemplate  = parse("[fg=255 bg=24][0][reset]")
echo btnTemplate.apply("┌────────────────────┐")
echo btnTemplate.apply("│       Submit       │")
echo btnTemplate.apply("└────────────────────┘")


