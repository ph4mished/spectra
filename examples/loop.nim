import times, strformat, ../src/spectra



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
