import ../src/spectra, strutils

echo "\n\n\n\n\n\n\n\n"
# Rich information display
paint("[c=33]┌─ Server Status ───────────────────────┐[reset]")
paint("[c=33]│[reset] CPU:  [c=46]42%[reset]  Memory: [c=118]68%[reset]  Disk: [c=190]85%[reset] [c=33]│[reset]")
paint("[c=33]│[reset] Users: [c=51]12[reset]   Uptime: [c=85]15d[reset]   Load: [c=196]2.1[reset]  [c=33]│[reset]")
paint("[c=33]└───────────────────────────────────────┘[reset]")

# From light to dark blues(blue spectrum)
paint("[c=51]Sky[reset] [c=45]Azure[reset] [c=39]Ocean[reset] [c=33]Royal[reset] [c=27]Navy[reset] [c=21]Midnight[reset]")

# Nature-inspired greens (green varieties)
paint("[c=46]Lime[reset] [c=76]Grass[reset] [c=106]Forest[reset] [c=64]Olive[reset] [c=58]Moss[reset]")



# Sunset palette
paint("[c=216]Peach[reset] [c=209]Coral[reset] [c=202]Sunset[reset] [c=196]Ruby[reset] [c=124]Wine[reset]")


# Perfect for UI elements
paint("[c=255]White[reset] [c=252]Light[reset] [c=248]Silver[reset] [c=244]Gray[reset] [c=240]Dark[reset] [c=232]Black[reset]")


# Visualize data intensity
proc heatColor(value: int): string =
  case value
  of 0..20: "c=46"
  of 21..40: "c=118" 
  of 41..60: "c=190"
  of 61..80: "c=208"
  else: "c=196"

const temp = 100
paint("[$1]●[reset] Temperature: $2°C" % [heatColor(temp), $temp])



# Colorful logos and banners
paint("[c=51]  ██████  [c=45]  ██████  [reset]")
paint("[c=51]██[c=45]░░░░░░██[c=39]░░░░░░██[reset]")
paint("[c=51]  ██████  [c=39]  ██████  [reset]")



# Multi-colored progress
proc progressBar(percent: int): string =
  let blocks = percent div 2
  result = "[c=46]" & "■".repeat(min(blocks, 25)) & "[reset]"
  result &= "[c=190]" & "■".repeat(max(0, blocks - 25)) & "[reset]"
  result &= "[c=244]" & "□".repeat(50 - blocks) & "[reset]"

paint(progressBar(100) & " 100%")


paint("[c=33]┌────────────┐[reset]")
paint("[c=33]│  Submit    │[reset]") 
paint("[c=33]└────────────┘[reset]")




# Form layout
paint("[bold #FF6B6B]┌─ User Registration ──────────────────┐[reset]")
paint("[bold #FF6B6B]│[reset] Name:  [c=255][underline]               [reset] [bold #FF6B6B]│[reset]")
paint("[bold #FF6B6B]│[reset] Email: [c=255][underline]               [reset] [bold #FF6B6B]│[reset]")
paint("[bold #FF6B6B]│[reset]       [c=255 bg=28]   Register   [reset]            [bold #FF6B6B]│[reset]")
paint("[bold #FF6B6B]└─────────────────────────────────────┘[reset]")





# Dashboard panels
paint("[c=255 bg=21]┌─ System Status ──────────────────────┐[reset]")
paint("[c=255 bg=21]│[reset] CPU:    [c=46]42% [/c=118]■■■■■■□□□□[reset]        [c=255 bg=21]│[reset]")
paint("[c=255 bg=21]│[reset] Memory: [c=190]68% [/c=208]■■■■■■■■□□[reset]        [c=255 bg=21]│[reset]")
paint("[c=255 bg=21]│[reset] Disk:   [c=196]85% [/c=196]■■■■■■■■■□[reset]        [c=255 bg=21]│[reset]")
paint("[c=255 bg=21]└──────────────────────────────────────┘[reset]")




proc showFileManager() =
  paint("[bold #4ECDC4]┌─ File Manager ───────────────────────────────────┐[reset]")
  paint("[bold #4ECDC4]│[reset] [c=51]📁 documents/[reset]                            [bold #4ECDC4]│[reset]")
  paint("[bold #4ECDC4]│[reset] [c=51]📁 pictures/[reset]                             [bold #4ECDC4]│[reset]")
  paint("[bold #4ECDC4]│[reset] [c=255]📄 report.pdf[reset]      [c=244]2.4 MB[reset]              [bold #4ECDC4]│[reset]")
  paint("[bold #4ECDC4]│[reset] [c=255]📄 data.csv[reset]        [c=244]1.1 MB[reset]              [bold #4ECDC4]│[reset]")
  paint("[bold #4ECDC4]│[reset]                                               [bold #4ECDC4]│[reset]")
  paint("[bold #4ECDC4]│[reset] [c=28 bg=255] F1 Help [reset] [c=196 bg=255] F5 Copy [reset] [c=202 bg=255] F6 Move [reset] [bold #4ECDC4]│[reset]")
  paint("[bold #4ECDC4]└──────────────────────────────────────────────────┘[reset]")
  
showFileManager()
  
  

proc showInstallWizard(step: int) =
  let steps = ["Setup", "Install", "Configure", "Complete"]
  
  paint("[bold #277DA1]┌─ Software Installation ─────────────────────────┐[reset]")
  
  # Progress steps
  for i, s in steps:
    if i < step:
      paint("[bold #277DA1]│[reset] [c=46]✓[reset] [c=255]$1[reset]" % [s] & " ".repeat(30) & "[bold #277DA1]│[reset]")
    elif i == step:
      paint("[bold #277DA1]│[reset] [c=226]●[reset] [bold]$1[reset]" % [s] & " ".repeat(30) & "[bold #277DA1]│[reset]")
    else:
      paint("[bold #277DA1]│[reset] [c=244]○ $1[reset]" % [s] & " ".repeat(30) & "[bold #277DA1]│[reset]")
  
  paint("[bold #277DA1]└──────────────────────────────────────────────────┘[reset]")
  
  
showInstallWizard(12)
  
  
proc showDataTable() =
  paint("[bold #43AA8B]┌──────────┬────────────┬────────────┐[reset]")
  paint("[bold #43AA8B]│[reset] [bold]Name[reset]     [bold #43AA8B]│[reset] [bold]Status[reset]     [bold #43AA8B]│[reset] [bold]Progress[reset]   [bold #43AA8B]│[reset]")
  paint("[bold #43AA8B]├──────────┼────────────┼────────────┤[reset]")
  paint("[bold #43AA8B]│[reset] User A   [bold #43AA8B]│[reset] [c=46]Online[reset]     [bold #43AA8B]│[reset] [c=46]██████[reset]     [bold #43AA8B]│[reset]")
  paint("[bold #43AA8B]│[reset] User B   [bold #43AA8B]│[reset] [c=196]Offline[reset]    [bold #43AA8B]│[reset] [c=208]████[reset]       [bold #43AA8B]│[reset]")
  paint("[bold #43AA8B]│[reset] User C   [bold #43AA8B]│[reset] [c=46]Online[reset]     [bold #43AA8B]│[reset] [c=46]███████[reset]    [bold #43AA8B]│[reset]")
  paint("[bold #43AA8B]└──────────┴────────────┴────────────┘[reset]")
  
showDataTable()
  
proc showDialog(title, message: string) =
  let width = max(title.len, message.len) + 4
  
  paint("[c=255 bg=236]┌─" & "─".repeat(width) & "─┐[reset]")
  paint("[c=255 bg=236]│[reset] [bold]$1[reset] " % [title] & " ".repeat(width - title.len - 1) & "[c=255 bg=236]│[reset]")
  paint("[c=255 bg=236]│[reset] " & " ".repeat(width) & " [c=255 bg=236]│[reset]")
  paint("[c=255 bg=236]│[reset] $1[reset] " % [message] & " ".repeat(width - message.len - 1) & "[c=255 bg=236]│[reset]")
  paint("[c=255 bg=236]│[reset] " & " ".repeat(width) & " [c=255 bg=236]│[reset]")
  paint("[c=255 bg=236]│[reset] [c=46 bg=236] OK [reset]  [c=196 bg=236] Cancel [reset]" & " ".repeat(width - 16) & "[c=255 bg=236]│[reset]")
  paint("[c=255 bg=236]└─" & "─".repeat(width) & "─┘[reset]")
  
showDialog("Open", "Done")]#
  
  
proc showTabs(activeTab: int) =
  let tabs = ["Files", "Edit", "View", "Help"]
  
  # Tab headers
  var tabLine = ""
  for i, tab in tabs:
    if i == activeTab:
      tabLine &= "[c=232 bg=51] $1 [reset]" % [tab]
    else:
      tabLine &= "[c=255 bg=240] $1 [reset]" % [tab]
  
  echo tabLine



  
  # Content area
  paint("[c=51]┌──────────────────────────────────────────────────┐[reset]")
  paint("[c=51]│[reset] Content for [bold]$1[reset] tab" % [tabs[activeTab]] & " ".repeat(25) & "[c=51]│[reset]")
  paint("[c=51]└──────────────────────────────────────────────────┘[reset]")]#


showTabs(-5)
  
  
# Complex dashboard - STILL READABLE
paint("[bold #277DA1]┌─ System Dashboard ───────────────────────────────────┐[reset]")
paint("[bold #277DA1]│[reset] CPU:  [c=46]42%[reset] [c=118]████████████████████[/c=244]██████████[reset]             [bold #277DA1]│[reset]")
paint("[bold #277DA1]│[reset] RAM:  [c=190]68%[reset] [c=208]████████████████████████[/c=244]████[reset]               [bold #277DA1]│[reset]")
paint("[bold #277DA1]│[reset] Disk: [c=196]85%[reset] [c=196]███████████████████████████[/c=244]█[reset]               [bold #277DA1]│[reset]")
paint("[bold #277DA1]├──────────────────────────────────────────────────────┤[reset]")
paint("[bold #277DA1]│[reset] [c=51]➤[reset] Process A [c=244](12% CPU)[reset]                                [bold #277DA1]│[reset]")
paint("[bold #277DA1]│[reset] [c=244] ○ Process B (8% CPU)[reset]                                [bold #277DA1]│[reset]")
paint("[bold #277DA1]│[reset] [c=244] ○ Process C (5% CPU)[reset]                                [bold #277DA1]│[reset]")
paint("[bold #277DA1]└──────────────────────────────────────────────────────┘[reset]")



paint("[bold #277DA1]┌─ System Status ─────────────────┐[/bold #277DA1]")
paint("[bold #277DA1]│[/bold #277DA1] CPU:  [c=46]42%[/c=46]                       [bold #277DA1]│[/bold /#277DA1]")
paint("[bold #277DA1]│[/bold #277DA1] RAM:  [c=190]68%[/c=190]                       [bold #277DA1]│[/bold /#277DA1]")
paint("[bold #277DA1]│[/bold #277DA1] Disk: [c=196]85%[/c=196]                       [bold #277DA1]│[/bold /#277DA1]")
paint("[bold #277DA1]└─────────────────────────────────┘[/bold #277DA1]")


# Normal button
paint("[c=255 bg=24]┌────────────┐[/c=255 /bg=24]")
paint("[c=255 bg=24]│  Submit    │[/c=255 /bg=24]")
paint("[c=255 bg=24]└────────────┘[/c=255 /bg=24]")

# Focused button
paint("[c=232 bg=51]┌────────────┐[/c=232 /bg=51]")
paint("[c=232 bg=51]│  Submit    │[/c=232 /bg=51]") 
paint("[c=232 bg=51]└────────────┘[/c=232 /bg=51]")




# Title
paint("[bold #FF6B6B]┌─ Settings Menu ────────────────────────────────┐[/bold /#FF6B6B]")

# Checkbox group
paint("[bold #FF6B6B]│[/bold #FF6B6B] [c=46][✓][/c=46] Enable notifications                       [bold #FF6B6B]│[/bold /#FF6B6B]")
paint("[bold #FF6B6B]│[/bold /#FF6B6B] [c=244][ ][/c=244] Auto-update                                [bold #FF6B6B]│[/bold /#FF6B6B]")
paint("[bold #FF6B6B]│[/bold /#FF6B6B] [c=244][ ][/c=244] Dark mode                                  [bold #FF6B6B]│[/bold /#FF6B6B]")

# Radio buttons  
paint("[bold #FF6B6B]│[/bold #FF6B6B]                                             [bold #FF6B6B]│[/bold #FF6B6B]")
paint("[bold #FF6B6B]│[/bold #FF6B6B] [c=46](●)[/c=46] Light theme                                [bold #FF6B6B]│[/bold #FF6B6B]")
paint("[bold #FF6B6B]│[/bold #FF6B6B] [c=244]( )[/c=244] Dark theme                            [bold #FF6B6B]│[/bold #FF6B6B]")
paint("[bold #FF6B6B]│[/bold #FF6B6B] [c=244]( )[/c=244] Auto theme                            [bold #FF6B6B]│[/bold #FF6B6B]")

# Buttons
paint("[bold #FF6B6B]│[/bold /#FF6B6B]                                        [bold #FF6B6B]│[/bold /#FF6B6B]")
paint("[bold #FF6B6B]│[/bold /#FF6B6B] [c=255 bg=28]┌────────┐[/c=255 /bg=28]  [c=244 bg=236]┌────────┐[/c=244 /bg=236]                        [bold #FF6B6B]│[/bold /#FF6B6B]")
paint("[bold #FF6B6B]│[/bold /#FF6B6B] [c=255 bg=28]│  Save  │[/c=255 /bg=28]  [c=244 bg=236]│ Cancel │[/c=244 /bg=236]             [bold #FF6B6B]│[/bold /#FF6B6B]")
paint("[bold #FF6B6B]│[/bold /#FF6B6B] [c=255 bg=28]└────────┘[/c=255 /bg=28]  [c=244 bg=236]└────────┘[/c=244 /bg=236]                         [bold #FF6B6B]│[/bold /#FF6B6B]")

paint("[bold #FF6B6B]└────────────────────────────────────────────────┘[/bold /#FF6B6B]")
]#


paint("[bold #277DA1]┌──────────┬──────────┬────────────┬────────┐[/bold /#277DA1]")
paint("[bold #277DA1]│[/bold /#277DA1] [bold]Name[/bold]     [bold #277DA1]│[/bold /#277DA1] [bold]Status[/bold]   [bold #277DA1]│[/bold /#277DA1] [bold]Last Active[/bold][bold #277DA1]│[/bold /#277DA1] [bold]Role[/bold]   [bold #277DA1]│[/bold /#277DA1]")
paint("[bold #277DA1]├──────────┼──────────┼────────────┼────────┤[/bold #277DA1]")
paint("[bold #277DA1]│[/bold /#277DA1] John     [bold #277DA1]│[/bold /#277DA1] [c=46]Online[/c=46]   [bold #277DA1]│[/bold /#277DA1] 2 min ago  [bold #277DA1]│[/bold /#277DA1] Admin  [bold #277DA1]│[/bold #277DA1]")
paint("[bold #277DA1]│[/bold /#277DA1] Sarah    [bold #277DA1]│[/bold /#277DA1] [c=196]Offline[/c=196]  [bold #277DA1]│[/bold /#277DA1] 1 day ago  [bold #277DA1]│[/bold /#277DA1] User   [bold #277DA1]│[/bold /#277DA1]")
paint("[bold #277DA1]│[/bold /#277DA1] Mike     [bold #277DA1]│[/bold #277DA1] [c=46]Online[/c=46]   [bold #277DA1]│[/bold /#277DA1] 5 min ago  [bold #277DA1]│[/bold /#277DA1] User   [bold #277DA1]│[/bold #277DA1]")
paint("[bold #277DA1]└──────────┴──────────┴────────────┴────────┘[/bold /#277DA1]")





# Left sidebar + main content
paint("[c=232 bg=51]┌─ NAVIGATION ──────────────────────────────┐[/c=232 /bg=51]")
paint("[c=232 bg=51]│[/c=232 /bg=51] [bold]➤ Dashboard[/bold]                               [c=232 bg=51]│[/c=232 /bg=51]")
paint("[c=232 bg=51]│[/c=232 /bg=51]   Users                                   [c=232 bg=51]│[/c=232 /bg=51]")
paint("[c=232 bg=51]│[/c=232 /bg=51]   Settings                                [c=232 bg=51]│[/c=232 /bg=51]")
paint("[c=232 bg=51]│[/c=232 /bg=51]   Analytics                               [c=232 bg=51]│[/c=232 /bg=51]")
paint("[c=232 bg=51]└───────────────────────────────────────────┘[/c=232 /bg=51]")

# Main content area would go to the right




paint("[c=51]Home[/c=51] [c=244]›[/c=244] [c=51]Settings[/c=51] [c=244]›[/c=244] [c=51]User Management[/c=51] [c=244]›[/c=244] [bold]Edit User[/bold]")




# Tooltip above element
paint("[c=255 bg=236]┌────────────────────┐[/c=255 /bg=236]")
paint("[c=255 bg=236]│ Click to edit user │[/c=255 /bg=236]")
paint("[c=255 bg=236]└────────────────────┘[/c=255 /bg=236]")
paint("         [c=255 bg=236]▲[/c=255 /bg=236]")
paint("    [c=51][Edit][/c=51]")




paint("[c=255 bg=236]┌─────────────────────────────────────────────────────┐[/c=255 /bg=236]")
paint("[c=255 bg=236]│[/c=255 /bg=236] [bold]Confirm Delete[/bold]                                      [c=255 bg=236]│[/c=255 /bg=236]")
paint("[c=255 bg=236]│[/c=255 /bg=236]                                                     [c=255 bg=236]│[/c=255 /bg=236]")
paint("[c=255 bg=236]│[/c=255 /bg=236] Are you sure you want to delete this user?          [c=255 bg=236]│[/c=255 /bg=236]")
paint("[c=255 bg=236]│[/c=255 /bg=236] This action cannot be undone.                       [c=255 bg=236]│[/c=255 /bg=236]")
paint("[c=255 bg=236]│[/c=255 /bg=236]                                                     [c=255 bg=236]│[/c=255 /bg=236]")
paint("[c=255 bg=236]│[/c=255 /bg=236]     [c=255 bg=196] Delete [/c=255 /bg=196]      [c=255 bg=240] Cancel [/c=255 /bg=240]                          [c=255 bg=236]│[/c=255 /bg=236]")
paint("[c=255 bg=236]└─────────────────────────────────────────────────────┘[/c=255 /bg=236]")




paint("[c=244]┌─ Search ───────────────────────────────────────────┐[/c=244]")
paint("[c=244]│[/c=244] [c=255]🔍 [/c=255][underline]type to search...                         [/underline]      [c=244]│[/c=244]")
paint("[c=244]└────────────────────────────────────────────────────┘[/c=244]")




# Animated spinner (would need to be updated)
paint("[c=51]⣷[/c=51] Loading user data...")
# Then later:
paint("[c=51]⣯[/c=51] Loading user data...")
# etc.

echo "\n\n\n\n\n\n\n\n"