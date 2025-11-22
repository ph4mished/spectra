# Current issues of spectra
Spectra does parse string and convert them to ansi color codes.
If in a loop, it becomes ineffiecient to use spectra due to repeated reparsing.
Builders, or precompiled will have to be implemented for such purposes.

## Builder form
``` nim

#inefficient spectra
for i in 1..1000:
  paint(fmt"[fg=cyan]Processing...{i}[reset]")
  #slow due to reparsing overhead



#Using precompiled
#just an idea
let filaname = "example.txt"
let status = spectra.compile("[fg=cyan]Processing[0] for [1][reset]")
for i in 0..1000:
  status.apply(i, filename)
  #where i = [0] and filename = [1]
```

# New issue
reparsing issue solved, now its 32x faster. now spectra need caching,
apply() gets the compiled results in segments and it needs to put them together, making it quite a bit expensive. so now it puts it together once and caches it, making it efficient for loops