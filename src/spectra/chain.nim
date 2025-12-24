import color

#let inner = parse("[bold][fg=red]Danger[reset]")
let outer = parse("[bold fg=red]Warning: [s][reset]")
echo outer.apply() #inner.apply())
