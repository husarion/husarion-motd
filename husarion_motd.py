#!/usr/bin/python3

import os
import subprocess
import socket

class FontColors:
    RED = "\x1b[31m"
    LIGHT_RED = "\x1b[91m"
    WHITE = "\x1b[37m"
    RESET = "\x1b[39m"


def horizontal_motd(title, logo, base_info_text):
    splitted_title = title.split('\n')
    splitted_logo = logo.split('\n')
    for i in range(len(splitted_title)):
        splitted_logo[i] += FontColors.RESET
        splitted_logo[i] += ' '
        splitted_logo[i] += splitted_title[i]


    docs_idx = len(splitted_title)
    splitted_logo[docs_idx] += FontColors.LIGHT_RED
    splitted_logo[docs_idx] += '  '
    splitted_logo[docs_idx] += base_info_text['user']
    splitted_logo[docs_idx] += FontColors.RESET
    splitted_logo[docs_idx] += '@'
    splitted_logo[docs_idx] += FontColors.LIGHT_RED
    splitted_logo[docs_idx] += base_info_text['hostname']
    splitted_logo[docs_idx+1] += '  ' + FontColors.RESET + '='*(len(base_info_text['user']) + len(base_info_text['hostname']) + 1)
    docs_idx += 2

    keys_order = ['Website', 'OS', 'Kernel', 'Board', 'Uptime', 'Memory']
    for i, key in enumerate(keys_order):
        splitted_logo[docs_idx+i] += FontColors.LIGHT_RED
        splitted_logo[docs_idx+i] += f'  {key}: '
        splitted_logo[docs_idx+i] += FontColors.RESET
        splitted_logo[docs_idx+i] += base_info_text[key]
    return '\n' + '\n'.join(splitted_logo) + '\n'


def vertical_motd(title, base_info_text):
    out = f'  {FontColors.LIGHT_RED}{base_info_text["user"]}{FontColors.RESET}@{FontColors.LIGHT_RED}{base_info_text["hostname"]}\n'
    out += '  ' + FontColors.RESET + '='*(len(base_info_text['user']) + len(base_info_text['hostname']) + 1)
    out += '\n'
    keys_order = ['Website', 'OS', 'Kernel', 'Board', 'Uptime', 'Memory']
    for i, key in enumerate(keys_order):
        out += FontColors.LIGHT_RED
        out += f'  {key}: '
        out += FontColors.RESET
        out += base_info_text[key]
        out += '\n'

    return '\n' + title + out


if __name__ == '__main__':
    title_file = open(os.getcwd() + '/title.txt', 'r')
    title = title_file.read()
    title_file.close()

    title_short_file = open(os.getcwd() + '/title_short.txt', 'r')
    title_short = title_short_file.read()
    title_short_file.close()

    husarion_logo_file = open(os.getcwd() + '/husarion_logo.txt', 'r')
    husarion_logo = husarion_logo_file.read()
    husarion_logo_file.close()

    operating_system = subprocess.check_output('''awk -F= '$1=="VERSION" { print $2 ;}' /etc/os-release''', shell=True)
    operating_system = str(operating_system).split('"')[1]

    kernel = subprocess.check_output('uname -r', shell=True)
    kernel = str(kernel)[2:-3]

    uptime = subprocess.check_output('uptime | awk -F\'( |,|:)+\' \'{print $6,$7\",\",$8,\"hours,\",$9,\"minutes.\"}\'', shell=True)
    uptime = str(uptime)[2:-3]

    memory_available = subprocess.check_output('df -BMiB / | awk \'NR == 2{print $2+0}\'', shell=True)
    memory_available = str(memory_available)[2:-3]

    memory_used = subprocess.check_output('df -BMB / | awk \'NR == 2{print $3+0}\'', shell=True)
    memory_used = str(memory_used)[2:-3]

    memory_percent = subprocess.check_output('df -BMB / | awk \'NR == 2{print $5+0}\'', shell=True)
    memory_percent = str(memory_percent)[2:-3]


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

    if terminal_width >= title_width + logo_width + 5:
        print(horizontal_motd(title, husarion_logo, base_info_text))
    elif terminal_width >= title_short_width + logo_width + 1:
        print(horizontal_motd(title_short, husarion_logo, base_info_text))
    elif terminal_width >= max(title_short_width, logo_width):
        print(vertical_motd(title_short, base_info_text))
    else:
        base_info_text = base_info_text.split(': ')
        print(f'\nn{base_info_text[0]}:\n{base_info_text[1]}\n\n')