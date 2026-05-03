when defined(windows):
  import winlean

  type
    DWORD = int32
    HANDLE = int

  const
    ENABLE_VIRTUAL_TERMINAL_PROCESSING = 0X0004
    ENABLE_WRAP_AT_EOL_OUTPUT = 0x0002
    ENABLE_PROCESSED_OUTPUT = 0x0001
    STDOUT_OUTPUT_HANDLE = -11

  proc getStdHandle(nStdHandle: int): HANDLE {.stdcall, dynlib: "kernel32", importc: "GetStdHandle".}
  proc getConsoleMode(hConsoleHandle: HANDLE, lpMode: var DWORD): int32 {.stdcall, dynlib: "kernel32", importc: "GetConsoleMode".}
  proc setConsoleMode(hConsoleHandle: HANDLE, dwMode: DWORD): int32 {.stdcall, dynlib: "kernel32", importc: "SetConsoleMode".}

  proc isWindowsTerminal(): bool =
    let handle = getStdHandle(STDOUT_OUTPUT_HANDLE)
    var mode: DWORD
    if getConsoleMode(handle, mode) != 0:
      # Set VT Mode
      let result = setConsoleMode(handle, mode or ENABLE_VIRTUAL_TERMINAL_PROCESSING)
      return result != 0
    return false

  proc enableVTProcessing() = 
    let handle = getStdHandle(STDOUT_OUTPUT_HANDLE)
    var mode: DWORD
    if getConsoleMode(handle, mode) != 0:
        let newMode = mode or ENABLE_VIRTUAL_TERMINAL_PROCESSING
        discard setConsoleMode(handle, newMode)


  # Auto run when module loads
  proc init() {.init.} = 
    enableVTProcessing()


