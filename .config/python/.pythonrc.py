# mxfng | 2021 - Personal Python Configuration File

import os
import sys
import atexit
import readline
import rlcompleter

# Tab Completion
readline.parse_and_bind("tab: complete")


# Personalized Prompt
class PersonalPrompt(object):
    def __init__(self):
        self.line = 0

    def __str__(self):
        self.line += 1
        return "\033[92m %d:\033[0m " % (self.line)


sys.ps1 = PersonalPrompt()
sys.ps2 = "    \033[91m...\033[0m "

# Re-direct History File
cache = os.path.join(os.path.expanduser("~"), ".cache/python")
historyPath = os.path.join(cache, "python_history")

if not os.path.exists(cache):
    os.makedirs(cache)


def save_history(historyPath=historyPath):
    import readline

    try:
        readline.write_history_file(historyPath)
    except IOError:
        pass


if os.path.exists(historyPath):
    readline.read_history_file(historyPath)

atexit.register(save_history)
del os, atexit, readline, rlcompleter, save_history, historyPath

# Custom Functions


def clear():  # Clear Console
    import os

    os.system("clear")


type(exit).__repr__ = lambda self: self()  # Exit Python Interpreter
