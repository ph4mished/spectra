# Current issues of spectra
Spectra does parse string and convert them to ansi color codes.
If in a loop, it becomes ineffiecient to use spectra due to repeated reparsing.
Builders, or precompilation will have to be implemented for such purposes.

## Builder form
``` nim

#inefficient spectra
for i in 1..1000000:
  paint(fmt"[fg=cyan]Processing...{i}[reset]")
  #slow due to reparsing overhead
  #completed in 195.3 sec


#Using precompiled
let status = spectra.compile("[fg=cyan]Processing[0] for [1][reset]")

for i in 0..1000000:
  status.apply(i, "example.txt")
  #completed in 3 sec


```
# Solved
reparsing issue solved, now its 32x faster. Precompilation made this possible.

# New issue 2
apply() gets the compiled results in segments and it needs to put them together, making it quite a bit expensive.  about 6 times slower than normal formatting when in loops/repeated calls and thats too much.

## Planned Soln
- apply() puts it together once and caches it, making it efficient for loops [Caching couldnt help]

**Caching only worked when compiled templates that needed no arguments.**

## Solved
Pre-allocation gave spectra performance gain of about 2x-3x that of the former (new = ~3.8 secs ||| old = ~6.5 sec)