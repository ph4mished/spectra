import ../src/spectra/[color, term], strutils, strformat, terminal

#the planning for term ui creation.
#the pseudocode for term ui usage
# Network Scanner UI
#[app "NetMapper":
  screen "scanner":
    panel "[bold red]Network Recon[reset]":
      input "Target Range", app.target
      button "[bg=196] Port Scan [reset]", proc() =
        let results = nmapScan(app.target)
        route "results"
    
    panel "[bold blue]Host Discovery[reset]":
      button "[bg=27] Ping Sweep [reset]", proc() =
        discoverHosts(app.target)
      button "[bg=39] Service Detect [reset]", proc() =
        detectServices(app.target)

  screen "results":
    panel "[bold green]Scan Results[reset]":
      for host in app.discoveredHosts:
        line fmt"[c=46]✓ {host.ip}[reset] - {host.services.join(", ")}"


# Vuln Scanner Dashboard
app "VulnHunter":
  panel "[bold #FF6B6B]Target Analysis[reset]":
    input "URL/IP", app.target
    select "Scan Type", app.scanType, options = ["Quick", "Full", "Custom"]
    button "[bg=208] Start Assessment [reset]", proc() =
      startVulnScan(app.target, app.scanType)

  panel "[bold #4ECDC4]Live Results[reset]":
    progress "Scanning: " & app.currentEndpoint
    for vuln in app.foundVulns:
      line fmt"[c=196]⚠ {vuln.name}[reset] - {vuln.severity}"




# Password Cracking Interface
app "HashBreaker":
  panel "[bold magenta]Hash Cracker[reset]":
    input "Hash", app.targetHash
    select "Hash Type", app.hashType, options = ["MD5", "SHA1", "SHA256"]
    input "Wordlist", app.wordlist
    
    button "[bg=34] Dictionary Attack [reset]", proc() =
      startDictionaryAttack(app.targetHash, app.wordlist)
    button "[bg=208] Brute Force [reset]", proc() =
      startBruteForce(app.targetHash)

  panel "[bold yellow]Progress[reset]":
    progressBar app.crackProgress
    line fmt"Tried: {app.attempts} passwords"
    line fmt"Speed: {app.speed} hashes/sec"




# WiFi Auditor
app "AirSpectra":
  panel "[bold cyan]Wireless Networks[reset]":
    dropdown "Interface", app.interface, options = getInterfaces()
    button "[bg=51] Scan Networks [reset]", proc() =
      app.networks = scanWifi(app.interface)
    
    for network in app.networks:
      line fmt"{network.ssid} [c=244]({network.signal}%)[reset]"
      button "[bg=196] Capture [reset]", proc() =
        startCapture(network.bssid)

  panel "[bold red]Capture Monitor[reset]":
    progress "Capturing handshakes..."
    line fmt"Packets: {app.packetCount}"
    line fmt"Handshakes: {app.handshakeCount}"




# Web Vulnerability Scanner
app "WebHunter":
  panel "[bold green]Web Target[reset]":
    input "URL", app.targetUrl
    checkbox "SQL Injection", app.checkSQLi
    checkbox "XSS", app.checkXSS
    checkbox "Directory Traversal", app.checkDirTraversal
    
    button "[bg=34] Start Scan [reset]", proc() =
      startWebScan(app.targetUrl)

  panel "[bold orange]Vulnerabilities[reset]":
    for vuln in app.webVulns:
      case vuln.severity:
      of "Critical": line fmt"[c=196]CRITICAL: {vuln.type}[reset]"
      of "High": line fmt"[c=208]HIGH: {vuln.type}[reset]"
      of "Medium": line fmt"[c=226]MEDIUM: {vuln.type}[reset]"



# Real-time Network Monitor
app "NetWatch":
  panel "[bold blue]Live Traffic[reset]":
    line fmt"Packets/sec: [c=46]{app.packetsPerSecond}[reset]"
    line fmt"Bandwidth: [c=51]{app.bandwidth} MB/s[reset]"
    
    for connection in app.activeConnections:
      line fmt"{connection.src} → {connection.dst} [c=244]({connection.protocol})[reset]"

  panel "[bold red]Alerts[reset]":
    for alert in app.securityAlerts:
      line fmt"[c=196]🚨 {alert.description}[reset]"
      button "[bg=52] Block [reset]", proc() =
        blockIP(alert.sourceIP)


# Phishing Toolkit
app "SocialEngine":
  panel "[bold purple]Campaign Manager[reset]":
    input "Target Email", app.targetEmail
    select "Template", app.template, options = ["Office365", "Google", "Facebook"]
    button "[bg=93] Send Test [reset]", proc() =
      sendPhishingTest(app.targetEmail, app.template)

  panel "[bold cyan]Results[reset]":
    line fmt"Sent: {app.emailsSent}"
    line fmt"Opened: {app.emailsOpened}"
    line fmt"Clicked: {app.linksClicked}"
    progress "Success Rate: " & app.successRate]#



#the actual usage of term ui
#[var p = newPanel("[bold bgRed yellow] Alert [reset]")
p.width = 45
p.height = 4
p.borderColor = "c=255 bg=236"
p.backgroundColor = "bgBlue"
p.addLine "[bold]Confirm delete"
p.addLine ""
p.addLine "Are you sure you want to delete this user?"
p.addLine "This action cannot be undone"
render(p)
echo ""
var btn = newButton("[bold blue] Delete [reset]")
btn.borderColor = "bold blue"
btn.width = 8
#renderBtn(btn)
p.add(btn) #this adds the button to the alert panel
renderBtn(btn)

echo ""
var inp = newInput("[bold blue]Name[yellow]")
inp.width = 30
renderInput(inp)]#

#let x, y = getCursorPos()

#echo fmt "X: {x}\n Y: {y}"
when isMainModule:
  var app = newPanel("My Terminal App")
  app.width = terminalWidth()-12
  app.height = terminalHeight()-12
  app.borderColor = "bold blue"
  app.backgroundColor = "black"
  app.textColor = "white"
  
  # Add components
  #create label
  app.add(newLabel("Welcome to the App!"))

  #create input
  var user = newInput("Username")
  user.position = @[2,3]
  var password = newInput("Password")
  password.position = @[2, 5]
  app.add(user, password)
  #app.addLine("Be careful", @[7,9])

  #create buttons
  var loginBtn = newButton("Login")
  loginBtn.position = @[5, 7]
  var exitBtn = newButton("Exit")
  exitBtn.position = @[25, 7]


  var opt = newOption(@["hey", "sup", "no", "yh"])
  opt.position = @[27, 2]
  app.add(opt)
  echo opt.optionLabels
  
  # Add buttons to panel
  app.add(loginBtn)
  app.add(exitBtn)

  app.draw()

  var soft = newPanel("Hello world")
  soft.width = terminalWidth()-15
  soft.height = terminalHeight()-12
  soft.draw()

  #[let key = getch()
  case key
  of 'q':
    exitPanel()
    echo "Closed"]#
  #echo opt

  #let x, y = getCursorPos()

  #echo fmt "X: {x}\n Y: {y}"