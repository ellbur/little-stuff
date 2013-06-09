
from docutils.parsers.rst import directives, Directive
import urllib2

class LoadDirective(Directive):
    
    required_arguments = 1
    
    def run(self):
        url = self.arguments[0]
        response = urllib2.urlopen(url)
        content = response.read()
        
        exec content in { }
        
        return []

def setup():
    directives.register_directive('load', LoadDirective)

