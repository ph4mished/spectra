import strformat, ../src/spectra


# Simple template with one placeholder
let greeting = parse("[fg=green]Hello, [0][reset]!")
    
echo greeting.apply("Alice")
echo greeting.apply("Bob")
echo greeting.apply("World")
    
# Complex template with multiple placeholders
let logTemplate = parse("[0] [fg=blue][1][reset]: [fg=yellow][2][reset]")
    
# Different log levels
echo logTemplate.apply("[INFO]", "main", "Application started")
echo logTemplate.apply("[WARN]", "auth", "Token expiring soon")
echo logTemplate.apply("[ERROR]", "db", "Connection failed")
