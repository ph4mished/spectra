# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import unittest, os

#use "include" so as to be able to even access private procs
include spectra

#[
- Test without interpolation
- with interpolation
- bad nuts
- escapes 
- color toggling
]#


suite "TESTING PLACEHOLDER SUBSTITUTION":
  test "WITHOUT PLACEHOLDER":
    check parse("[fg=green]Hello World[reset]") == CompiledTemplate(parts: @[TempPart(text: "\e[32m", index: -1), TempPart(text: "Hello World", index: -1), TempPart(text: "\e[0m", index: -1)], totalLength: 28)

    check parse("[fg=green]Hello World[reset]").apply() == "\e[32mHello World\e[0m"
  

  test "WITH PLACEHOLDER":
    check parse("[fg=green]Hello [0][reset]") == CompiledTemplate(parts: @[TempPart(text: "\e[32m", index: -1), TempPart(text: "Hello ", index: -1), TempPart(text: "", index: 0), TempPart(text: "\e[0m", index: -1)], totalLength: 26)

    check parse("[fg=green]Hello [0][reset]").apply("World") == "\e[32mHello World\e[0m"


  
suite "TESTING ESCAPES":
  test "BAD NUTS AS ESCAPES":
    check parse("[fg=red][fg=green strk]Hello [0][reset]") == CompiledTemplate(parts: @[TempPart(text: "\e[31m", index: -1), TempPart(text: "[fg=green strk]", index: -1), TempPart(text: "Hello ", index: -1), TempPart(text: "", index: 0), TempPart(text: "\e[0m", index: -1)], totalLength: 39)

    check parse("[fg=red][fg=green strk]Hello [0][reset]").apply("World") == "\e[31m[fg=green strk]Hello World\e[0m"


  test "NON-TAGS AS ESCAPES":
    check parse("[fg=red][strk]Hello World[reset]") == CompiledTemplate(parts: @[TempPart(text: "\e[31m", index: -1), TempPart(text: "[strk]", index: -1), TempPart(text: "Hello World", index: -1), TempPart(text: "\e[0m", index: -1)], totalLength: 32)

    check parse("[fg=red][strk]Hello World[reset]").apply() == "\e[31m[strk]Hello World\e[0m"


  test "APPLY() FOR ESCAPES":
    check parse("[fg=red][0]Hello World[reset]").apply("[bold fg=green]") == "\e[31m[bold fg=green]Hello World\e[0m"



suite "TESTING COLOR TOGGLING":
  test "DEFAULT COLOR TOGGLE":
    
    putEnv("NO_COLOR", "1")
    let toggle1 = newColorToggle()
    check toggle1.parse("[fg=red]Hello World[reset]").apply() == "Hello World"

    delEnv("NO_COLOR")
    let toggle2 = newColorToggle()
    check toggle2.parse("[fg=red]Hello World[reset]").apply() == "\e[31mHello World\e[0m"

  test "COLOR TOGGLED ON":
    putEnv("NO_COLOR", "1") #Terminal coloring set to false
    let toggle1 = newColorToggle(true)
    check toggle1.parse("[fg=red]Hello World[reset]").apply() == "\e[31mHello World\e[0m"

  test "COLOR TOGGLED OFF":
    delEnv("NO_COLOR")   #Terminal color set to true
    let toggle2 = newColorToggle(false)
    check toggle2.parse("[fg=red]Hello World[reset]").apply() == "Hello World"
