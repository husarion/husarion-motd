#!/usr/bin/python3

import os
import subprocess
import socket

# Bash color codes
class TextColors:
    RED = '\x1b[31m'
    LIGHT_RED = '\x1b[91m'
    WHITE = '\x1b[37m'
    RESET = '\x1b[39m'


def horizontal_motd(title, logo, base_info_text):
    split_title = title.split('\n')
    split_logo = logo.split('\n')
    # combine logo and title text
    for i in range(len(split_title)):
        split_logo[i] += f'{TextColors.RESET} {split_title[i]}'

    docs_idx = len(split_title) - 1
    # show logged user name and hostname
    split_logo[docs_idx] += f'{TextColors.LIGHT_RED} {base_info_text["user"]}{TextColors.RESET}@{TextColors.LIGHT_RED}{base_info_text["hostname"]}'
    # draw horizontal line to separate user from stats
    split_logo[docs_idx+1] += '  ' + TextColors.RESET + '='*(len(base_info_text['user']) + len(base_info_text['hostname']) + 1)
    docs_idx += 2
    # show stats in given order
    keys_order = ['Website', 'OS', 'Kernel', 'Board', 'Uptime', 'Memory']
    for i, key in enumerate(keys_order):
        split_logo[docs_idx+i] += f'{TextColors.LIGHT_RED}  {key}: {TextColors.RESET}{base_info_text[key]}'
    return '\n'.join(split_logo)


def vertical_motd(title, base_info_text):
    # show logged user name and hostname
    out = f'  {TextColors.LIGHT_RED}{base_info_text["user"]}{TextColors.RESET}@{TextColors.LIGHT_RED}{base_info_text["hostname"]}\n'
    # draw horizontal line to separate user from stats
    out += '  ' + TextColors.RESET + '='*(len(base_info_text['user']) + len(base_info_text['hostname']) + 1)
    out += '\n'
    # show stats in given order
    keys_order = ['Website', 'OS', 'Kernel', 'Board', 'Uptime', 'Memory']
    for key in keys_order:
        out += f'{TextColors.LIGHT_RED}  {key}: {TextColors.RESET}{base_info_text[key]}\n'
    return title + out


def main(title, title_short, husarion_logo):
    # get operating system name
    operating_system = subprocess.check_output('''awk -F= '$1=="VERSION" { print $2 ;}' /etc/os-release''', shell=True)
    operating_system = str(operating_system).split('"')[1]

    # get kernel version
    kernel = subprocess.check_output('uname -r', shell=True)
    kernel = str(kernel)[2:-3]

    # get time how long system is already running
    uptime = subprocess.check_output('uptime -p', shell=True)
    # replace days, hours, minutes with d. h. m.
    uptime = str(uptime)[5:-3].replace(' days,', 'd.').replace(' day,', 'd.')
    uptime = uptime.replace(' hours,', 'h.').replace(' hour,', 'h.')
    uptime = uptime.replace(' minutes', 'm.').replace(' minute', 'm.')

    # get how much memory is available for root partition
    memory_available = subprocess.check_output('df -BMiB / | awk \'NR == 2{print $2+0}\'', shell=True)
    memory_available = str(memory_available)[2:-3]

    # get how much memory is used on root partition
    memory_used = subprocess.check_output('df -BMB / | awk \'NR == 2{print $3+0}\'', shell=True)
    memory_used = str(memory_used)[2:-3]

    # get how many percent of memory is used
    memory_percent = subprocess.check_output('df -BMB / | awk \'NR == 2{print $5+0}\'', shell=True)
    memory_percent = str(memory_percent)[2:-3]

    # map computer stats to dict
    base_info_text = {
        'user': os.getenv('USER'),
        'hostname': socket.gethostname(),
        'Website': 'https://husarion.com/',
        'Board': os.getenv('SBC_NAME_FANCY'),
        'OS': operating_system,
        'Kernel': kernel,
        'Uptime': uptime,
        'Memory': f'{memory_used}MiB / {memory_available}MiB ({memory_percent}%)'
    }

    title_width = len(title.split('\n')[1])
    title_short_width = len(title_short.split('\n')[1])
    logo_width = len(husarion_logo.split('\n')[1])

    # Force white color on the whole logo
    husarion_logo = [TextColors.WHITE + c for c in husarion_logo]
    husarion_logo = ''.join(husarion_logo)
    # Replace color from white to read for all slash symbols
    husarion_logo = husarion_logo.replace(TextColors.WHITE + '/', TextColors.RED + '/')

    # get current terminal window width
    _, terminal_width = os.popen('stty size', 'r').read().split()
    terminal_width = int(terminal_width)

    # entice graphic can fit the terminal window
    window_padding = 5
    if terminal_width >= title_width + logo_width + window_padding:
        print(horizontal_motd(title, husarion_logo, base_info_text))
    # reduced graphic has to be used since image won't fit the screen
    elif terminal_width >= title_short_width + logo_width + 1:
        print(horizontal_motd(title_short, husarion_logo, base_info_text))
    # Simplified graphic has to be shown
    else:
        print(vertical_motd(title, base_info_text))

# __main__ callback added after creation of logos

