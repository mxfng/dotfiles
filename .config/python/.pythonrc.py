import os
import atexit
import readline

# Tab Completion
readline.parse_and_bind('tab: complete')

# Re-direct History File
cache = os.path.join(os.path.expanduser('~'), '.cache/python')
history = os.path.join(cache, 'python_history')

if not os.path.exists(cache):
    os.makedirs(cache)

try:
    readline.read_history_file(history)
except OSError:
    pass

def write_history():
    try:
        readline.write_history_file(history)
    except OSError:
        pass

atexit.register(write_history)