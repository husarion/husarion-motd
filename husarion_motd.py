#!/usr/bin/python3

import os
import subprocess
import socket

# Bash color codes
class FontColors:
    RED = "\x1b[31m"
    LIGHT_RED = "\x1b[91m"
    WHITE = "\x1b[37m"
    RESET = "\x1b[39m"


def horizontal_motd(title, logo, base_info_text):
    splitted_title = title.split('\n')
    splitted_logo = logo.split('\n')
    # combine logo and title text
    for i in range(len(splitted_title)):
        splitted_logo[i+1] += f'{FontColors.RESET} {splitted_title[i]}'

    docs_idx = len(splitted_title)+1
    # show logged user name and hostname
    splitted_logo[docs_idx] += f'{FontColors.LIGHT_RED}  {base_info_text["user"]}{FontColors.RESET}@{FontColors.LIGHT_RED}{base_info_text["hostname"]}'
    # draw horizontal line to separate user from stats
    splitted_logo[docs_idx+1] += '  ' + FontColors.RESET + '='*(len(base_info_text['user']) + len(base_info_text['hostname']) + 1)
    docs_idx += 2
    # show stats in given order
    keys_order = ['Website', 'OS', 'Kernel', 'Board', 'Uptime', 'Memory']
    for i, key in enumerate(keys_order):
        splitted_logo[docs_idx+i] += f'{FontColors.LIGHT_RED}  {key}: {FontColors.RESET}{base_info_text[key]}'
    return '\n' + '\n'.join(splitted_logo) + '\n'


def vertical_motd(title, base_info_text):
    # show logged user name and hostname
    out = f'  {FontColors.LIGHT_RED}{base_info_text["user"]}{FontColors.RESET}@{FontColors.LIGHT_RED}{base_info_text["hostname"]}\n'
    # draw horizontal line to separate user from stats
    out += '  ' + FontColors.RESET + '='*(len(base_info_text['user']) + len(base_info_text['hostname']) + 1)
    out += '\n'
    # show stats in given order
    keys_order = ['Website', 'OS', 'Kernel', 'Board', 'Uptime', 'Memory']
    for key in keys_order:
        out += f'{FontColors.LIGHT_RED}  {key}: {FontColors.RESET}{base_info_text[key]}\n'
    return '\n' + title + out


if __name__ == '__main__':
    # import title graphic
    title_file = open(os.getcwd() + '/title.txt', 'r')
    title = title_file.read()
    title_file.close()

    # import multiline title graphic
    title_short_file = open(os.getcwd() + '/title_short.txt', 'r')
    title_short = title_short_file.read()
    title_short_file.close()

    # import Husarion logo
    husarion_logo_file = open(os.getcwd() + '/husarion_logo.txt', 'r')
    husarion_logo = husarion_logo_file.read()
    husarion_logo_file.close()

    # get operating system name
    operating_system = subprocess.check_output('''awk -F= '$1=="VERSION" { print $2 ;}' /etc/os-release''', shell=True)
    operating_system = str(operating_system).split('"')[1]

    # get kernel version
    kernel = subprocess.check_output('uname -r', shell=True)
    kernel = str(kernel)[2:-3]

    # get how long system is up
    uptime = subprocess.check_output('uptime | awk -F\'( |,|:)+\' \'{print $6,$7\",\",$8,\"hours,\",$9,\"minutes.\"}\'', shell=True)
    uptime = str(uptime)[2:-3].replace(' days,', 'd.').replace(' hours,', 'h.').replace(' minutes.', 'm.')

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
    base_info_text = {'user': os.getenv('USER'),
                      'hostname': socket.gethostname(),
                      'Website': 'https://husarion.com/',
                      'Board': os.getenv('SBC_NAME_FANCY'),
                      'OS': operating_system,
                      'Kernel': kernel,
                      'Uptime': uptime,
                      'Memory': f'{memory_used}MB / {memory_available}MB ({memory_percent}%)'
                      }

    title_width = len(title.split('\n')[0])
    title_short_width = len(title_short.split('\n')[0])
    logo_width = len(husarion_logo.split('\n')[0])
    info_width = len(base_info_text)

    husarion_logo = husarion_logo.replace('%', FontColors.RED + 'w')
    husarion_logo = husarion_logo.replace('.', FontColors.WHITE + '#')

    _, terminal_width = os.popen('stty size', 'r').read().split()
    terminal_width = int(terminal_width)

    # Full graphic can fit and window is over 80 characters wide
    if terminal_width >= title_width + logo_width + 5 and terminal_width > 79:
        print(horizontal_motd(title, husarion_logo, base_info_text))
    # Reduced graphic has to be used and window is over 80 character wide
    elif terminal_width >= title_short_width + logo_width + 1 and terminal_width > 79:
        print(horizontal_motd(title_short, husarion_logo, base_info_text))
    # Simplified graphic has to be shown
    else:
        print(vertical_motd(title_short, base_info_text))