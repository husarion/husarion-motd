import osproc, posix, os, strutils

var TIOCGWINSZ {.importc, header: "<sys/ioctl.h>".}: uint

const logo = """
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%.%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%...%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%...%%%%...%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%....%%%...%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%....%%...%%%%%%%%%%%%%%%%%
%%%%%%%%%%....%%%.....%...%%%%%%%%%%%%%%%%%
%%%%%%%%%%%......%%...%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%......%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%..%%....%%%%%%%%%%%%%%%%%%%
%%%%%%%%........%%%%....%%%%%%%%%%%%%%%%%%%
%%%%%%%%%.........%%....%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%....%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%......%%%....%%%%%%%%%%%%%%%%%%%
%%%%%%%%..........%%....%%%%%....%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%....%%%%%....%%%%%%%%%%
%%%%%%%%%%%....%%%%%....%%%%%....%%%%%%%%%%
%%%%%%%%..........%%.............%%%%%%%%%%
%%%%%%%%%%.....%%%%%.............%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%....%%%%%....%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%....%%%%%....%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%....%%%%%....%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"""

when not defined(pro):
  const title = """
 _____    ____    _____  _             _     ___      ___  
|  __ \  / __ \  / ____|| |           | |   |__ \    / _ \ 
| |__) || |  | || (___  | |__    ___  | |_     ) |  | | | |
|  _  / | |  | | \___ \ | '_ \  / _ \ | __|   / /   | | | |
| | \ \ | |__| | ____) || |_) || (_) || |_   / /_  _| |_| |
|_|  \_\ \____/ |_____/ |_.__/  \___/  \__| |____|(_)\___/ 

"""

when defined(pro):
  const title = """
 _____    ____    _____  _             _     ___      ___    _____   _____    ____  
|  __ \  / __ \  / ____|| |           | |   |__ \    / _ \  |  __ \ |  __ \  / __ \ 
| |__) || |  | || (___  | |__    ___  | |_     ) |  | | | | | |__) || |__) || |  | |
|  _  / | |  | | \___ \ | '_ \  / _ \ | __|   / /   | | | | |  ___/ |  _  / | |  | |
| | \ \ | |__| | ____) || |_) || (_) || |_   / /_  _| |_| | | |     | | \ \ | |__| |
|_|  \_\ \____/ |_____/ |_.__/  \___/  \__| |____|(_)\___/  |_|     |_|  \_\ \____/ 

"""

const baseInfoText = """Documentation: https://husarion.com/manuals/"""

const
  redFont = "\x1b[31m"
  whiteFont = "\x1b[37m"
  resetFont = "\x1b[39m"

proc getWindowWidth(): int =
  type winsize = object
    ws_row: cushort
    ws_col: cushort
    ws_xpixel: cushort
    ws_ypixel: cushort

  var w: winsize
  if ioctl(0, TIOCGWINSZ, addr w) < 0:
    exitnow 0

  return w.ws_col.int

proc renderColors(t: string): string =
  result = ""
  var currentColor = ""
  for ch in t:
    let newColor = if ch == '%': redFont else: whiteFont
    if currentColor != newColor:
      result &= newColor
      currentColor = newColor
    result &= "#"
  result &= resetFont

proc generateInfo(): string =
  result = "\L"
  result &= baseInfoText
  result &= "\L"

const
  logoWidth = logo.split('\L')[0].len
  titleWidth = title.split('\L')[0].len
  logoSpacing = 2

let
  infoText = generateInfo()
  windowWidth = getWindowWidth()
  showLogo = logoWidth + titleWidth + logoSpacing < windowWidth
  showTitle = titleWidth < windowWidth
  rightText = if showTitle: title & infoText.replace("\L", "\L    ")
              else: infoText

if showLogo:
  let logoArray = logo.split('\L')
  let rightArray = rightText.split('\L')
  for i in 0..<logoArray.len:
    echo renderColors(logoArray[i]), if i < rightArray.len: rightArray[i] else: ""
else:
  echo rightText
