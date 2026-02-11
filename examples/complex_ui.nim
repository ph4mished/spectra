import strutils, ../src/spectra
    
# Table with colored headers
let headerTemplate = parse("[bold fg=cyan][0][reset]")
let rowTemplate = parse("[0]  [fg=yellow][1][reset]  [fg=green][2][reset]")
    
echo headerTemplate.apply("─".repeat(40))
echo headerTemplate.apply("USER MANAGEMENT")
echo headerTemplate.apply("─".repeat(40))
    
echo rowTemplate.apply("Alice", "admin", "active")
echo rowTemplate.apply("Bob", "user", "active")
echo rowTemplate.apply("Charlie", "guest", "inactive")
    
# Nested templates
let errorTemplate = parse("[bold fg=red][0][reset]: [1]")
let suggestionTemplate = parse("[fg=yellow]Suggestion: [0][reset]")
 
 
type Err = object
  code: string
  msg: string
  suggestion: string
  

var errors: seq[Err]
errors.add(Err(code: "E001", msg: "File not found", suggestion: "Check the file path"))
errors.add(Err(code: "E002", msg: "Permission denied", suggestion: "Run with sudo or check permissions"))
errors.add(Err(code: "E003", msg: "Out of memory", suggestion: "Close other applications"))

for err in errors:
  echo errorTemplate.apply(err.code, err.msg)
  echo "  " & suggestionTemplate.apply(err.suggestion)
  echo "\n" 
