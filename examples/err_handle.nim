import ../src/spectra, tables

# Template for showing validation errors
let validationTemplate = parse("[fg=red]• [0]: [1][reset]")
    
let errors = {
  "username": "Must be at least 3 characters",
  "email":    "Invalid email format",
  "password": "Must contain uppercase and numbers"
}.toTable
    
echo parse("[bold fg=yellow]Validation Errors:[reset]").apply()
for field, message in errors:
  echo validationTemplate.apply(field, message)


# Template with conditional formatting
let scoreTemplate = parse("[0]: [1]")
 
type Score = object
  name: string
  score: int
 
var scores: seq[Score]

scores.add(Score(name: "Alice", score: 95))
scores.add(Score(name: "Bob", score: 75))
scores.add(Score(name: "Charlie", score: 45))
scores.add(Score(name: "Diana", score: 60))

   
for s in scores:
  var scoreColor: string
  if s.score >= 90:
    scoreColor = "[fg=green bold]"
  elif s.score >= 70:
    scoreColor = "[fg=yellow]"
  else:
    scoreColor = "[fg=red]"
  let coloredScore = parse(scoreColor & $s.score & "[reset]").apply()
  echo scoreTemplate.apply(s.name, coloredScore)
