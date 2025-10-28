when isMainModule:
  var app = newPanel("My Terminal App")
  app.width = 60
  app.height = 15
  app.borderColor = "blue"
  app.backgroundColor = "black"
  app.textColor = "white"
  
  # Add components
  app.add(newLabel("Welcome to the App!"))
  app.add(newInput("Username"))
  app.add(newInput("Password")) 
  
  # Create buttons
  var loginBtn = newButton("Login")
  var exitBtn = newButton("Exit")
  
  # Add buttons to panel
  app.add(loginBtn)
  app.add(exitBtn)
  
  # Manual positioning - place Exit next to Login
  loginBtn.position = @[2, 8]    # x=2, y=8
  exitBtn.position = @[15, 8]    # x=15 (right of Login), y=8
  
  # Don't call pack() since we're positioning manually
  app.draw()