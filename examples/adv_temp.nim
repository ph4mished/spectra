import os, strformat, ../src/spectra

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
