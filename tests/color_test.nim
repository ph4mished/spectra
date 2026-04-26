#Test for helper functions
import unittest, os, strutils, strformat
include spectra/[color_helpers, palette]


# =============================
# NEW COLOR TOGGLE TESTS
# =============================
suite "NEW COLOR TOGGLE TESTS":
  setup:
    let origNoColor = os.getEnv("NO_COLOR")
    let origTerm = os.getEnv("TERM")
  teardown:
    os.putEnv("NO_COLOR", origNoColor)
    os.putEnv("TERM", origTerm)

  test "NEW COLOR TOGGLE DEFAULT":
    #os.unsetEnv("NO_COLOR")
    os.putEnv("TERM", "xterm-256color")

    let toggle = newC

# =============================
# NEW COLOR TOGGLE TESTS
# =============================
suite "NEW COLOR TOGGLE TESTS":
  setup:
 olorToggle()
    check toggle != nil

  
  test "NEW COLOR TOGGLE WITH TRUE":
    let toggle =  newColorToggle(true)
    check toggle != nil 
    check toggle.enableColor = true

  test "NEW COLOR TOGGLE WITH FALSE":
    let toggle = newColorToggle(false)
    check toggle != nil
    check toggle.enableColor(false)

  test "NEW COLOR TOGGLE WITH MULTIPLE ARGS":
    let toggle = newColorToggle(true, false)
    check toggle != nil 
    check togge.enableColor == true

  test "NEW COLOR TOGGLE WITH NO ARGS":
    let toggle = newColorToggle()
    check toggle != nil



# =============================
# PARSE FUNCTION TESTS
# =============================

func TestParse_BasicText(t *testing.T) {
	template := Parse("Hello World")
	
	if template.TotalLength != 11 {
		t.Errorf("Expected TotalLength 11, got %d", template.TotalLength)
	}
	
	if len(template.Parts) != 1 {
		t.Errorf("Expected 1 part, got %d", len(template.Parts))
	}
	
	if template.Parts[0].Text != "Hello World" {
		t.Errorf("Expected 'Hello World', got '%s'", template.Parts[0].Text)
	}
}

func TestParse_WithColorTag(t *testing.T) {
	template := Parse("[fg=red]Hello")
	
	# Should have at least one part (the color code)
	if len(template.Parts) < 1 {
		t.Errorf("Expected at least 1 part, got %d", len(template.Parts))
	}
	
	# TotalLength should be original input length
	if template.TotalLength != 13 { # "[fg=red]Hello" = 12 chars
		t.Errorf("Expected TotalLength 13, got %d", template.TotalLength)
	}
}

func TestParse_WithPlaceholders(t *testing.T) {
	template := Parse("Hello [0], welcome [1]")
	
	if len(template.Parts) != 4 {
		t.Errorf("Expected 4 parts, got %d", len(template.Parts))
	}
	
	# Check placeholder indices
	found0 := false
	found1 := false
	for _, part := range template.Parts {
		if part.Index == 0 {
			found0 = true
		}
		if part.Index == 1 {
			found1 = true
		}
	}
	
	if !found0 {
		t.Error("Placeholder [0] not found")
	}
	if !found1 {
		t.Error("Placeholder [1] not found")
	}
}


func TestParse_ComplexTemplate(t *testing.T) {
	template := Parse("[fg=blue bold][0:<20][reset] [fg=green][1][reset]")
	
	if template.TotalLength != 49 { # Length of the input string
		t.Errorf("Expected TotalLength 49, got %d", template.TotalLength)
	}
	
	# Should have multiple parts for colors, placeholders, and resets
	if len(template.Parts) < 5 {
		t.Errorf("Expected at least 5 parts, got %d", len(template.Parts))
	}
}

func TestParse_EmptyString(t *testing.T) {
	template := Parse("")
	
	if template.TotalLength != 0 {
		t.Errorf("Expected TotalLength 0, got %d", template.TotalLength)
	}
	
	if len(template.Parts) != 0 {
		t.Errorf("Expected 0 parts, got %d", len(template.Parts))
	}
}

func TestParse_OnlyBrackets(t *testing.T) {
	template := Parse("[]")
	
	if template.TotalLength != 2 {
		t.Errorf("Expected TotalLength 2, got %d", template.TotalLength)
	}
	
	# Empty brackets should be treated as literal
	foundLiteral := false
	for _, part := range template.Parts {
		if part.Text == "[]" {
			foundLiteral = true
			break
		}
	}
	
	if !foundLiteral {
		t.Error("Empty brackets '[]' should be treated as literal")
	}
}

# =============================
# COLOR TOGGLE PARSE TESTS
# =============================
suite "COLOR TOGGLE PARSE TESTS":
  test "COLORS ENABLED":
    let toggle = newColorToggle(true)
    let temp = toggle.parse("[fg=red]Hello")
    var hasAnsiCode = false
    for part in temp.parts:
      if part.text != "" and part.text[0] == '\e':
        hasAnsiCode = true
        break
    check hasAnsiCode == true

  test "COLORS DISABLED":
    let toggle = newColorToggle(false)
    let temp = toggle.parse("[fg=red]Hello")
    for part in temp.parts:
        check part.text == ""
        check part.text[0] != '\e'

  
  test "NIL TOGGLE":
    var toggle: newColorToggle = nil 
    let temp = toggle.Parse("[fg=red]Hello")
    check temp.totalLength != 0

  test "PRESERVE TEXT":
    let toggle = newColorToggle(false)
    let input = "Hello [fg=red]World[reset]"
    let temp = toggle.parse(input)
    result = temp.a
func TestColorToggle_Parse_PreservesText(t *testing.T) {
	toggle := NewColorToggle(false)
	input := "Hello [fg=red]World[reset]!"
	template := toggle.Parse(input)
	
	# The text content should be preserved even without colors
	result := template.apply()
	
	# Should contain all the text (without ANSI codes)
	if !containsString(result, "Hello") {
		t.Error("Expected 'Hello' in result")
	}
	if !containsString(result, "World") {
		t.Error("Expected 'World' in result")
	}
	if !containsString(result, "!") {
		t.Error("Expected '!' in result")
	}
}

# =============================
# INTEGRATION TESTS
# =============================
suite "INTEGRATION TESTS":
  tests "PARSE AND APPLY":
    let temp = parse("[fg=cyan][0][reset] [bold][1][reset]")
    result = temp.apply("Hello", "World")
    check result.contains("Hello") == true
    check result.contains("World") == true

  test "PARSE WITH PADDING":
    let temp = parse("[0<20] is [1:>10]")
    result = temp.apply("Left", "Right")
    check result.len >= 30

  test "MULTIPLE PARSES":
    let temp1 = parse("[fg=red]Error: [0][reset]")
    let temp2 = parse("[fg=green]Success: [0][reset]")
    let res1 = temp1.apply("File not found")
    let res2 = temp2.apply("Operation complete")
    check res1.contains("Error") == true
    check res2.contains("Success") == true

  
  test "PARSE COMPLEX STYLES":
    let temp = parse("[bold underline=single fg=rgb(255,0,0)][0][reset]")
    result = temp.apply("Important")
    check result != ""
    check result.contains("Important") == true


# =============================
# EDGE CASE TEST
# =============================
suite "EDGE CASE TESTS":
  test "PARSE UNCLOSED BRACKETS":
    let temp = parse("[fg=red Unclosed bracket")
    var foundLiteral = false
    for part in temp.parts:
      if part.text.contains("[fg=red Unclosed brackter"):
        foundLiteral = true
        break
    check foundLiteral == true
    

  test "PARSE NESTED BRACKETS":
    let temp = parse("[[fg=red]]")
    var parsedColor = false
    for part in temp.parts:
      if part.text == "[":
        parsedColor = true
        break
    check parsedColor = true

	
  test "PARSE WHITESPACE ONLY":
    let temp = parse("   ")
    check temp.totalLength == 3
    check temp.parts.len == 1
    check temp.parts.text == "   "


  
  test "PARSE SPECIAL CHARACTERS":
    let temp = parse("Hello\nWorld\t![0]\r\n")
    check temp.totalLength == 18
    let result = temp.apply()
    check result.contains("\n") == true
    check result.contains("\t") == true
    check result.contains("\r") == true
	# Should preserve special characters


# =============================
# BENCHMARK TESTS
# =============================

func BenchmarkParse_Simple(b *testing.B) {
	for i := 0; i < b.N; i++ {
		Parse("Hello World")
	}
}

func BenchmarkParse_WithColors(b *testing.B) {
	for i := 0; i < b.N; i++ {
		Parse("[fg=red]Hello [bold]World[reset]")
	}
}

func BenchmarkParse_WithPlaceholders(b *testing.B) {
	for i := 0; i < b.N; i++ {
		Parse("[fg=cyan][0][reset] [fg=yellow][1][reset]")
	}
}

func BenchmarkParse_ComplexTemplate(b *testing.B) {
	tmpl := "[fg=blue bold][0:<20][reset] [fg=green][1:>10][reset] [fg=red]![reset]"
	for i := 0; i < b.N; i++ {
		Parse(tmpl)
	}
}

func BenchmarkColorToggle_Parse(b *testing.B) {
	toggle := NewColorToggle(true)
	tmpl := "[fg=red]Hello [bold]World[reset]"
	
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		toggle.Parse(tmpl)
	}
}

# =============================
# HELPER FUNCTIONS
# =============================

func containsString(s, substr string) bool {
	return len(s) >= len(substr) && (s == substr || len(substr) == 0 || 
		(len(s) > 0 && len(substr) > 0 && findSubstring(s, substr)))
}

func findSubstring(s, substr string) bool {
	for i := 0; i <= len(s)-len(substr); i++ {
		if s[i:i+len(substr)] == substr {
			return true
		}
	}
	return false
}

# =============================
# TABLE DRIVEN TESTS
# =============================

func TestParse_VariousInputs(t *testing.T) {
	tests := []struct {
		name     string
		input    string
		minParts int
	}{
		{"Empty", "", 0},
		{"Plain text", "Hello", 1},
		{"Single color", "[fg=red]text", 2},
		{"Multiple colors", "[fg=red][bg=blue]text", 3},
		{"Placeholder", "[0]", 1},
		{"Padded placeholder", "[0:<20]", 1},
		{"Escape", "[<fg=red>]", 1},
		{"Mixed", "Start [fg=red][0][reset] End", 4},
		{"Complex", "[bold fg=cyan][0:<20][reset] [fg=yellow][1][reset]!", 6},
	}
	
	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			template := Parse(test.input)
			
			if len(template.Parts) < test.minParts {
				t.Errorf("Expected at least %d parts, got %d", test.minParts, len(template.Parts))
			}
			
			if template.TotalLength != len(test.input) {
				t.Errorf("TotalLength = %d, expected %d", template.TotalLength, len(test.input))
			}
		})
	}
}

func TestNewColorToggle_VariousArgs(t *testing.T) {
	tests := []struct {
		name     string
		args     []bool
		expected *bool # nil means don't check specific value
	}{
		{"No args", []bool{}, nil},
		{"True", []bool{true}, boolPtr(true)},
		{"False", []bool{false}, boolPtr(false)},
		{"Multiple", []bool{true, false}, boolPtr(true)},
	}
	
	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			var toggle *ColorToggle
			if len(test.args) == 0 {
				toggle = NewColorToggle()
			} else {
				toggle = NewColorToggle(test.args...)
			}
			
			if toggle == nil {
				t.Fatal("Toggle should not be nil")
			}
			
			if test.expected != nil {
				if toggle.EnableColor != *test.expected {
					t.Errorf("EnableColor = %v, expected %v", toggle.EnableColor, *test.expected)
				}
			}
		})
	}
}

func boolPtr(b bool) *bool {
	return &b
}