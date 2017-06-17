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

const title = """
    _____ ____  _____  ______ ___        _____   ____   _____
   / ____/ __ \|  __ \|  ____|__ \      |  __ \ / __ \ / ____|
  | |   | |  | | |__) | |__     ) |_____| |__) | |  | | (___
  | |   | |  | |  _  /|  __|   / /______|  _  /| |  | |\___ \
  | |___| |__| | | \ \| |____ / /_      | | \ \| |__| |____) |
   \_____\____/|_|  \_\______|____|     |_|  \_\\____/|_____/

"""

const baseInfoText = """Documentation: https://docs.husarion.com
Remote access: https://cloud.husarion.com"""

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
