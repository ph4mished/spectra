import ../src/spectra, strutils

#Commented Examples need to be updated

echo "\n\n\n\n\n\n\n\n"
# Rich information display
#create precompiled tuples
let toggle = newColorToggle()
let temps = (
  header: toggle.parse("[fg=33]┌─ [0] ────────────────────┐[reset]"),
  body: toggle.parse("[fg=33]│[reset] [0]:  [fg=46][1][reset]  [2]: [fg=118][3][reset]  [4]: [fg=190][5] [fg=33]│[reset]"),
  foot: toggle.parse("[fg=33]└────────────────────────────────────┘[reset]")
)

echo temps.header.apply("Server Status")
echo temps.body.apply("CPU", "42%", "Memory", "68%", "Disk", "85% ")
echo temps.body.apply("Users", "12", "Uptime", "15d", "Load", "2.1")
echo temps.foot.apply()




# From light to dark blues(blue spectrum)
echo parse("[fg=51]Sky[reset] [fg=45]Azure[reset] [fg=39]Ocean[reset] [fg=33]Royal[reset] [fg=27]Navy[reset] [fg=21]Midnight[reset]").apply()

# Nature-inspired greens (green varieties)
echo parse("[fg=46]Lime[reset] [fg=76]Grass[reset] [fg=106]Forest[reset] [fg=64]Olive[reset] [fg=58]Moss[reset]").apply()



# Sunset palette
echo parse("[fg=216]Peach[reset] [fg=209]Coral[reset] [fg=202]Sunset[reset] [fg=196]Ruby[reset] [fg=124]Wine[reset]").apply()


# Perfect for UI elements
echo parse("[fg=255]White[reset] [fg=252]Light[reset] [fg=248]Silver[reset] [fg=244]Gray[reset] [fg=240]Dark[reset] [fg=232]Black[reset]").apply()



# Colorful logos and banners
echo parse("[fg=51]  [0]  [fg=45]  [0]  [reset]").apply("█".repeat(5))
echo parse("[fg=51][0][fg=45][1][0][fg=39][1][0][reset]").apply("█".repeat(2), "░".repeat(5))
echo parse("[fg=51]  [0]  [fg=39]  [0]  [reset]").apply("█".repeat(5))



# Multi-colored progress
#This is just an example, dont try this way for progress bars
proc progressBar(percent: int): string =
  let blocks = percent div 2
  result = "[fg=46]" & "■".repeat(min(blocks, 25)) & "[reset]"
  result &= "[fg=190]" & "■".repeat(max(0, blocks - 25)) & "[reset]"
  result &= "[fg=244]" & "□".repeat(50 - blocks) & "[reset]"

echo parse(progressBar(100) & " 100%").apply()




#[
# Form layout
paint("[bold #FF6B6B]┌─ User Registration ──────────────────┐[reset]")
paint("[bold #FF6B6B]│[reset] Name:  [fg=255][underline]               [reset] [bold #FF6B6B]│[reset]")
paint("[bold #FF6B6B]│[reset] Email: [fg=255][underline]               [reset] [bold #FF6B6B]│[reset]")
paint("[bold #FF6B6B]│[reset]       [fg=255 bg=28]   Register   [reset]            [bold #FF6B6B]│[reset]")
paint("[bold #FF6B6B]└─────────────────────────────────────┘[reset]")





# Dashboard panels
paint("[fg=255 bg=21]┌─ System Status ──────────────────────┐[reset]")
paint("[fg=255 bg=21]│[reset] CPU:    [fg=46]42% [/fg=118]■■■■■■□□□□[reset]        [fg=255 bg=21]│[reset]")
paint("[fg=255 bg=21]│[reset] Memory: [fg=190]68% [/fg=208]■■■■■■■■□□[reset]        [fg=255 bg=21]│[reset]")
paint("[fg=255 bg=21]│[reset] Disk:   [fg=196]85% [/fg=196]■■■■■■■■■□[reset]        [fg=255 bg=21]│[reset]")
paint("[fg=255 bg=21]└──────────────────────────────────────┘[reset]")




proc showFileManager() =
  paint("[bold #4ECDC4]┌─ File Manager ───────────────────────────────────┐[reset]")
  paint("[bold #4ECDC4]│[reset] [fg=51]📁 documents/[reset]                            [bold #4ECDC4]│[reset]")
  paint("[bold #4ECDC4]│[reset] [fg=51]📁 pictures/[reset]                             [bold #4ECDC4]│[reset]")
  paint("[bold #4ECDC4]│[reset] [fg=255]📄 report.pdf[reset]      [fg=244]2.4 MB[reset]              [bold #4ECDC4]│[reset]")
  paint("[bold #4ECDC4]│[reset] [fg=255]📄 data.csv[reset]        [fg=244]1.1 MB[reset]              [bold #4ECDC4]│[reset]")
  paint("[bold #4ECDC4]│[reset]                                               [bold #4ECDC4]│[reset]")
  paint("[bold #4ECDC4]│[reset] [fg=28 bg=255] F1 Help [reset] [fg=196 bg=255] F5 Copy [reset] [fg=202 bg=255] F6 Move [reset] [bold #4ECDC4]│[reset]")
  paint("[bold #4ECDC4]└──────────────────────────────────────────────────┘[reset]")
  
showFileManager()
  
  

proc showInstallWizard(step: int) =
  let steps = ["Setup", "Install", "Configure", "Complete"]
  
  paint("[bold #277DA1]┌─ Software Installation ─────────────────────────┐[reset]")
  
  # Progress steps
  for i, s in steps:
    if i < step:
      paint("[bold #277DA1]│[reset] [fg=46]✓[reset] [fg=255]$1[reset]" % [s] & " ".repeat(30) & "[bold #277DA1]│[reset]")
    elif i == step:
      paint("[bold #277DA1]│[reset] [fg=226]●[reset] [bold]$1[reset]" % [s] & " ".repeat(30) & "[bold #277DA1]│[reset]")
    else:
      paint("[bold #277DA1]│[reset] [fg=244]○ $1[reset]" % [s] & " ".repeat(30) & "[bold #277DA1]│[reset]")
  
  paint("[bold #277DA1]└──────────────────────────────────────────────────┘[reset]")
  
  
showInstallWizard(12)
  
  
proc showDataTable() =
  paint("[bold #43AA8B]┌──────────┬────────────┬────────────┐[reset]")
  paint("[bold #43AA8B]│[reset] [bold]Name[reset]     [bold #43AA8B]│[reset] [bold]Status[reset]     [bold #43AA8B]│[reset] [bold]Progress[reset]   [bold #43AA8B]│[reset]")
  paint("[bold #43AA8B]├──────────┼────────────┼────────────┤[reset]")
  paint("[bold #43AA8B]│[reset] User A   [bold #43AA8B]│[reset] [fg=46]Online[reset]     [bold #43AA8B]│[reset] [fg=46]██████[reset]     [bold #43AA8B]│[reset]")
  paint("[bold #43AA8B]│[reset] User B   [bold #43AA8B]│[reset] [fg=196]Offline[reset]    [bold #43AA8B]│[reset] [fg=208]████[reset]       [bold #43AA8B]│[reset]")
  paint("[bold #43AA8B]│[reset] User C   [bold #43AA8B]│[reset] [fg=46]Online[reset]     [bold #43AA8B]│[reset] [fg=46]███████[reset]    [bold #43AA8B]│[reset]")
  paint("[bold #43AA8B]└──────────┴────────────┴────────────┘[reset]")
  
showDataTable()
  
proc showDialog(title, message: string) =
  let width = max(title.len, message.len) + 4
  
  paint("[fg=255 bg=236]┌─" & "─".repeat(width) & "─┐[reset]")
  paint("[fg=255 bg=236]│[reset] [bold]$1[reset] " % [title] & " ".repeat(width - title.len - 1) & "[fg=255 bg=236]│[reset]")
  paint("[fg=255 bg=236]│[reset] " & " ".repeat(width) & " [fg=255 bg=236]│[reset]")
  paint("[fg=255 bg=236]│[reset] $1[reset] " % [message] & " ".repeat(width - message.len - 1) & "[fg=255 bg=236]│[reset]")
  paint("[fg=255 bg=236]│[reset] " & " ".repeat(width) & " [fg=255 bg=236]│[reset]")
  paint("[fg=255 bg=236]│[reset] [fg=46 bg=236] OK [reset]  [fg=196 bg=236] Cancel [reset]" & " ".repeat(width - 16) & "[fg=255 bg=236]│[reset]")
  paint("[fg=255 bg=236]└─" & "─".repeat(width) & "─┘[reset]")
  
showDialog("Open", "Done")
  
  
proc showTabs(activeTab: int) =
  let tabs = ["Files", "Edit", "View", "Help"]
  
  # Tab headers
  var tabLine = ""
  for i, tab in tabs:
    if i == activeTab:
      tabLine &= "[fg=232 bg=51] $1 [reset]" % [tab]
    else:
      tabLine &= "[fg=255 bg=240] $1 [reset]" % [tab]
  
  echo tabLine



  
  # Content area
  paint("[fg=51]┌──────────────────────────────────────────────────┐[reset]")
  paint("[fg=51]│[reset] Content for [bold]$1[reset] tab" % [tabs[activeTab]] & " ".repeat(25) & "[fg=51]│[reset]")
  paint("[fg=51]└──────────────────────────────────────────────────┘[reset]")


showTabs(-5)
  
  
# Complex dashboard - STILL READABLE
paint("[bold #277DA1]┌─ System Dashboard ───────────────────────────────────┐[reset]")
paint("[bold #277DA1]│[reset] CPU:  [fg=46]42%[reset] [fg=118]████████████████████[/fg=244]██████████[reset]             [bold #277DA1]│[reset]")
paint("[bold #277DA1]│[reset] RAM:  [fg=190]68%[reset] [fg=208]████████████████████████[/fg=244]████[reset]               [bold #277DA1]│[reset]")
paint("[bold #277DA1]│[reset] Disk: [fg=196]85%[reset] [fg=196]███████████████████████████[/fg=244]█[reset]               [bold #277DA1]│[reset]")
paint("[bold #277DA1]├──────────────────────────────────────────────────────┤[reset]")
paint("[bold #277DA1]│[reset] [fg=51]➤[reset] Process A [fg=244](12% CPU)[reset]                                [bold #277DA1]│[reset]")
paint("[bold #277DA1]│[reset] [fg=244] ○ Process B (8% CPU)[reset]                                [bold #277DA1]│[reset]")
paint("[bold #277DA1]│[reset] [fg=244] ○ Process C (5% CPU)[reset]                                [bold #277DA1]│[reset]")
paint("[bold #277DA1]└──────────────────────────────────────────────────────┘[reset]")



paint("[bold #277DA1]┌─ System Status ─────────────────┐[/bold #277DA1]")
paint("[bold #277DA1]│[/bold #277DA1] CPU:  [fg=46]42%[/fg=46]                       [bold #277DA1]│[/bold /#277DA1]")
paint("[bold #277DA1]│[/bold #277DA1] RAM:  [fg=190]68%[/fg=190]                       [bold #277DA1]│[/bold /#277DA1]")
paint("[bold #277DA1]│[/bold #277DA1] Disk: [fg=196]85%[/fg=196]                       [bold #277DA1]│[/bold /#277DA1]")
paint("[bold #277DA1]└─────────────────────────────────┘[/bold #277DA1]")






# Title
paint("[bold #FF6B6B]┌─ Settings Menu ────────────────────────────────┐[/bold /#FF6B6B]")

# Checkbox group
paint("[bold #FF6B6B]│[/bold #FF6B6B] [fg=46][✓][/fg=46] Enable notifications                       [bold #FF6B6B]│[/bold /#FF6B6B]")
paint("[bold #FF6B6B]│[/bold /#FF6B6B] [fg=244][ ][/fg=244] Auto-update                                [bold #FF6B6B]│[/bold /#FF6B6B]")
paint("[bold #FF6B6B]│[/bold /#FF6B6B] [fg=244][ ][/fg=244] Dark mode                                  [bold #FF6B6B]│[/bold /#FF6B6B]")

# Radio buttons  
paint("[bold #FF6B6B]│[/bold #FF6B6B]                                             [bold #FF6B6B]│[/bold #FF6B6B]")
paint("[bold #FF6B6B]│[/bold #FF6B6B] [fg=46](●)[/fg=46] Light theme                                [bold #FF6B6B]│[/bold #FF6B6B]")
paint("[bold #FF6B6B]│[/bold #FF6B6B] [fg=244]( )[/fg=244] Dark theme                            [bold #FF6B6B]│[/bold #FF6B6B]")
paint("[bold #FF6B6B]│[/bold #FF6B6B] [fg=244]( )[/fg=244] Auto theme                            [bold #FF6B6B]│[/bold #FF6B6B]")

# Buttons
paint("[bold #FF6B6B]│[/bold /#FF6B6B]                                        [bold #FF6B6B]│[/bold /#FF6B6B]")
paint("[bold #FF6B6B]│[/bold /#FF6B6B] [fg=255 bg=28]┌────────┐[/fg=255 /bg=28]  [fg=244 bg=236]┌────────┐[/fg=244 /bg=236]                        [bold #FF6B6B]│[/bold /#FF6B6B]")
paint("[bold #FF6B6B]│[/bold /#FF6B6B] [fg=255 bg=28]│  Save  │[/fg=255 /bg=28]  [fg=244 bg=236]│ Cancel │[/fg=244 /bg=236]             [bold #FF6B6B]│[/bold /#FF6B6B]")
paint("[bold #FF6B6B]│[/bold /#FF6B6B] [fg=255 bg=28]└────────┘[/fg=255 /bg=28]  [fg=244 bg=236]└────────┘[/fg=244 /bg=236]                         [bold #FF6B6B]│[/bold /#FF6B6B]")

paint("[bold #FF6B6B]└────────────────────────────────────────────────┘[/bold /#FF6B6B]")



paint("[bold #277DA1]┌──────────┬──────────┬────────────┬────────┐[/bold /#277DA1]")
paint("[bold #277DA1]│[/bold /#277DA1] [bold]Name[/bold]     [bold #277DA1]│[/bold /#277DA1] [bold]Status[/bold]   [bold #277DA1]│[/bold /#277DA1] [bold]Last Active[/bold][bold #277DA1]│[/bold /#277DA1] [bold]Role[/bold]   [bold #277DA1]│[/bold /#277DA1]")
paint("[bold #277DA1]├──────────┼──────────┼────────────┼────────┤[/bold #277DA1]")
paint("[bold #277DA1]│[/bold /#277DA1] John     [bold #277DA1]│[/bold /#277DA1] [fg=46]Online[/fg=46]   [bold #277DA1]│[/bold /#277DA1] 2 min ago  [bold #277DA1]│[/bold /#277DA1] Admin  [bold #277DA1]│[/bold #277DA1]")
paint("[bold #277DA1]│[/bold /#277DA1] Sarah    [bold #277DA1]│[/bold /#277DA1] [fg=196]Offline[/fg=196]  [bold #277DA1]│[/bold /#277DA1] 1 day ago  [bold #277DA1]│[/bold /#277DA1] User   [bold #277DA1]│[/bold /#277DA1]")
paint("[bold #277DA1]│[/bold /#277DA1] Mike     [bold #277DA1]│[/bold #277DA1] [fg=46]Online[/fg=46]   [bold #277DA1]│[/bold /#277DA1] 5 min ago  [bold #277DA1]│[/bold /#277DA1] User   [bold #277DA1]│[/bold #277DA1]")
paint("[bold #277DA1]└──────────┴──────────┴────────────┴────────┘[/bold /#277DA1]")





# Left sidebar + main content
paint("[fg=232 bg=51]┌─ NAVIGATION ──────────────────────────────┐[/fg=232 /bg=51]")
paint("[fg=232 bg=51]│[/fg=232 /bg=51] [bold]➤ Dashboard[/bold]                               [fg=232 bg=51]│[/fg=232 /bg=51]")
paint("[fg=232 bg=51]│[/fg=232 /bg=51]   Users                                   [fg=232 bg=51]│[/fg=232 /bg=51]")
paint("[fg=232 bg=51]│[/fg=232 /bg=51]   Settings                                [fg=232 bg=51]│[/fg=232 /bg=51]")
paint("[fg=232 bg=51]│[/fg=232 /bg=51]   Analytics                               [fg=232 bg=51]│[/fg=232 /bg=51]")
paint("[fg=232 bg=51]└───────────────────────────────────────────┘[/fg=232 /bg=51]")

# Main content area would go to the right


]#


let normal = parse("[fg=255 bg=24][0][1][2][reset]")
let focused = parse("[fg=232 bg=51][0][1][2][reset]")

echo normal.apply("┌", "─".repeat(12), "┐")
echo normal.apply("│", "   Submit   ", "│")
echo normal.apply("└", "─".repeat(12), "┘")
echo ""

echo focused.apply("┌", "─".repeat(12), "┐")
echo focused.apply("│", "   Cancel   ", "│")
echo focused.apply("└", "─".repeat(12), "┘")
echo ""


echo parse("[fg=51]Home [fg=244]› [fg=51]Settings [fg=244]› [fg=51]User Management [fg=244]› [bold]Edit User[reset]\n").apply


# Tooltip above element
let elem = parse("[fg=255 bg=236][0][1][2][reset]")

echo elem.apply("┌","─".repeat(20), "┐")
echo elem.apply("│", " Click to edit user ", "│")
echo elem.apply("└", "─".repeat(20), "┘")
echo elem.apply("", parse("[reset]          [fg=255 bg=236]▲").apply, "")
echo parse("       [fg=51][Edit][reset]\n").apply()





#[
paint("[fg=255 bg=236]┌─────────────────────────────────────────────────────┐[/fg=255 /bg=236]")
paint("[fg=255 bg=236]│[/fg=255 /bg=236] [bold]Confirm Delete[/bold]                                      [fg=255 bg=236]│[/fg=255 /bg=236]")
paint("[fg=255 bg=236]│[/fg=255 /bg=236]                                                     [fg=255 bg=236]│[/fg=255 /bg=236]")
paint("[fg=255 bg=236]│[/fg=255 /bg=236] Are you sure you want to delete this user?          [fg=255 bg=236]│[/fg=255 /bg=236]")
paint("[fg=255 bg=236]│[/fg=255 /bg=236] This action cannot be undone.                       [fg=255 bg=236]│[/fg=255 /bg=236]")
paint("[fg=255 bg=236]│[/fg=255 /bg=236]                                                     [fg=255 bg=236]│[/fg=255 /bg=236]")
paint("[fg=255 bg=236]│[/fg=255 /bg=236]     [fg=255 bg=196] Delete [/fg=255 /bg=196]      [fg=255 bg=240] Cancel [/fg=255 /bg=240]                          [fg=255 bg=236]│[/fg=255 /bg=236]")
paint("[fg=255 bg=236]└─────────────────────────────────────────────────────┘[/fg=255 /bg=236]")

]#

echo parse("""
[fg=224]┌─ Search ────────────────────┐[reset]
[fg=224]│ [fg=255]🔍[underline]type to search...      [underline=reset fg=224]   │[reset]
[fg=224]└─────────────────────────────┘[reset]
\n""").apply()



let spin = parse("[fg=51][0][reset] Loading user data...")

echo spin.apply("⣷")
echo spin.apply("⣯")

echo "\n\n\n\n\n\n"