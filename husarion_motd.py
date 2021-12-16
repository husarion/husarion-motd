#!/usr/bin/python3

import os

class FontColors:
    RED = "\x1b[31m"
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
    if len(base_info_text) >= len(splitted_title[0]):
        base_info_text = base_info_text.split(': ')
        splitted_logo[docs_idx] += FontColors.RESET
        splitted_logo[docs_idx] += ' '
        splitted_logo[docs_idx] += base_info_text[0]
        splitted_logo[docs_idx] += ':'

        splitted_logo[docs_idx+1] += FontColors.RESET
        splitted_logo[docs_idx+1] += ' '*2
        splitted_logo[docs_idx+1] += base_info_text[1]

    else:
        splitted_logo[docs_idx] += FontColors.RESET
        splitted_logo[docs_idx] += ' '
        splitted_logo[docs_idx] += base_info_text
    return '\n' + '\n'.join(splitted_logo) + '\n'


def vertical_motd(title, base_info_text):
    base_info_text = base_info_text.split(': ')

    return '\n' + title + '  ' + base_info_text[0] + ':\n   ' + base_info_text[1] + '\n'


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

    base_info_text = '''Documentation: https://husarion.com/manuals/'''

    title_width = len(title.split('\n')[0])
    title_short_width = len(title_short.split('\n')[0])
    logo_width = len(husarion_logo.split('\n')[0])
    info_width = len(base_info_text)

    husarion_logo = husarion_logo.replace('%', FontColors.RED + '#')
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