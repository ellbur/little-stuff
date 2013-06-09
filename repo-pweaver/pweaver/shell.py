
from subprocess import Popen
import urllib
import re

def shell(dir, *args):
    print(dir)
    print(args)
    status = Popen(args, cwd=dir).wait()
    if status != 0:
        raise NonzeroReturn

def path_escape(path):
    return re.sub('\\%', '', urllib.quote(path, safe=''))

class NonzeroReturn:
    def __init__(self):
        pass


