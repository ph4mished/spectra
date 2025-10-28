import ../src/spectra

#This example is to express how huewheel can be used for ascii arts

# Create gradient-like effects with multiple colors
#to recreate the unicde block below
#for linux, enter "Ctrl + Shift + u" and then type "2592" and press enter
echo "\n\n\n\n\n"
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



# Colored cat face
#[paint("""
[bold yellow]   /\\_/\\  
  ( o.o ) 
   > ^ <
[/bold yellow]
[white] 
   /\\_/\\  
  ( -.- ) 
   > ^ <
[/white]
""")



#Arrow
paint("""
[green]     *
    ***
   *****
  *******
 *********
[red]    ***
    ***
    ***
[/red]
""")



#Rocket
paint("""
[white]     /\\
    /  \\
   /____\\
[red]   |    |
   |    |
[/red][blue]  /|    |\\
 / |    | \\
[/blue][yellow]*  [red]/\\[/red]  [red]/\\[/red]  *
[/yellow]
""")



paint("""
[yellow]  -----
 | o o |
 |  ^  |
 | \\_/ |
  -----
[/yellow]

[cyan]  -----
 | • • |
 |  ▽  |
 | ___ |
  -----
[/cyan]
""")]#



paint("""
                  [bold red]▄▄▄▄▄[/red][#FF6600]▄▄▄▄▄[/#FF6600][yellow]▄▄▄▄▄[/yellow][green]▄▄▄▄▄[/green][blue]▄▄▄▄▄[/blue][#6600FF]▄▄▄▄▄[/#6600FF][magenta]▄▄▄▄▄[/magenta]
""")




#[
paint("""
[bold yellow]    *       *       *
       *       *    
  *         *        *
     *           *
        *     *
[yellow]    *       *       *
[/yellow]
""")



paint("""
[magenta]  .     .     .
   \\___/ \\___/
  /\\___/\\___/\\
  \\/___\\/___\\/
[blue]  .     .     .
[/blue]
""")]#

#ctrl+ shift+u + 250c = ┌
#ctrl+ shift+u + 2514 = └
#ctrl+ shift+u + 2518 = ┘
#ctrl+ shift+u + 2510 = ┐
#ctrl+ shift+u + 2500 = ─
#ctrl+ shift+u + 2502 = │
paint "                        [c=255 bg=24]┌────────────────────┐[reset]"
paint "                        [c=255 bg=24]│     Submit         │[reset]"
paint "                        [c=255 bg=24]└────────────────────┘[reset]"



