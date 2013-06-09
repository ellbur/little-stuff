
from docutils.parsers.rst import directives, Directive
from docutils import nodes

class HTMLHeadDirective(Directive):
    
    has_content = True
    
    class head(nodes.Special, nodes.PreBibliographic, nodes.Element):
        
        def __init__(self, content):
            nodes.Element.__init__(self)
            
            self['content'] = content
    
    def run(self):
        return [HTMLHeadDirective.head('\n'.join(self.content))]

directives.register_directive('html-head', HTMLHeadDirective)

