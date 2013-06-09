
from __future__ import print_function

import sys

from docutils.core import publish_parts
from docutils import nodes
from docutils.parsers.rst import directives, Directive

from haskell_color import haskell_to_html, haskell_css

from xml.sax.saxutils import escape
from tempfile import mkdtemp
from subprocess import Popen, PIPE
import re
from exceptions import Exception

class HaskellDirectiveContext(Directive):
    
    def __init__(self):

        self.files = { }
        
        self.wd = mkdtemp()
    
    def HaskellDirective(self):
        context = self

        class Factory(Directive):
            def __init__(self):
                self.optional_arguments = 5
                self.has_content = True
                self.option_spec = {
                    'name':  directives.unchanged,
                    'after': directives.unchanged
                }

            def __call__(self, *a, **b):
                return HaskellDirective(context, *a, **b)

        return Factory()
    
    def GHCIDirective(self):
        context = self

        class Factory(Directive):
            def __init__(self):
                self.optional_arguments = 1
                self.has_content = True
                self.option_spec = {
                }

            def __call__(self, *a, **b):
                return GHCIDirective(context, *a, **b)

        return Factory()
    
    def file(self, name):
        if not(name in self.files):
            self.files[name] = HaskellDirectiveFile(self, name)
        
        return self.files[name]
    
    def ghci(self, name, line):
        if name != None:
            self.file(name).write()

        command = ( ['ghc', name, '-e', line]
            if name != None
            else ['ghc', '-e', line]
        )

        ghci = Popen(
            command,
            stdout = PIPE,
            stderr = PIPE,
            cwd = self.wd
        )
        
        out, err = ghci.communicate()

        return remove_blank(err) + remove_blank(out)

class HaskellDirectiveFile:
    
    def __init__(self, context, name):
        self.context = context
        self.name    = name
        
        self.empty   = True
        self.version = 1
        self.blocks  = [ ]
        
    def feed(self, lines, name=None, after=None):
        new_block = Block(lines, name)

        if after == 'start':
            self.blocks.insert(0, new_block)
        elif after != None:
            for k in range(len(self.blocks)):
                block = self.blocks[k]
                if block.name == after:
                    self.blocks.insert(k+1, new_block)
                    break
            else:
                raise NameNotFound(after)
        else:
            self.blocks.append(new_block)

        self.empty = False
    
    def redo(self, lines, name):
        for block in self.blocks:
            if block.name == name:
                block.lines = lines
                break
        else:
            raise NameNotFound(name)
    
    def restart(self):
        self.empty = True
        self.blocks = [ ]
    
    def write(self):
        text = self.text()

        with open(self.path(), 'w') as fh:
            fh.write(text)

        with open(self.version_path(), 'w') as fh:
            fh.write(text)
        
        self.version += 1
    
    def text(self):
        lines = [ ]
        for block in self.blocks:
            lines += block.lines
        
        return '\n'.join(lines)
    
    def count_lines(self):
        return sum([
            len(block.lines) for block in self.blocks
        ])
    
    def start_line(self, block_name, after_name, redo):
        lines = 1

        if redo:
            for block in self.blocks:
                if block.name == block_name:
                    return lines
                lines += len(block.lines)
            else:
                raise NameNotFound(block_name)
        
        elif after_name == 'start':
            return 1
        
        elif after_name != None:
            for block in self.blocks:
                lines += len(block.lines)
                
                if block.name == after_name:
                    return lines
            else:
                raise NameNotFound(after_name)
        
        else:
            return self.count_lines() + 1
    
    def compile(self):
        self.write()

        ghc = Popen(
            ['ghc', '-c', '-o', '/dev/null', self.name],
            stdout = PIPE,
            stderr = PIPE,
            cwd = self.context.wd
        )
        out, err = ghc.communicate()
        
        return remove_blank(err)
    
    def run(self):
        self.write()

        runghc = Popen(
            ['runghc', self.name],
            stdout = PIPE,
            stderr = PIPE,
            cwd = self.context.wd
        )
        
        out, err = runghc.communicate()
        
        return remove_blank(err) + remove_blank(out)
    
    def path(self):
        return self.context.wd + '/' + self.name
    
    def version_path(self):
        d = self.name.rfind('.')
        base = self.name[:d]
        ext = self.name[d:]

        return (
            self.context.wd + '/' +
            base + '-' + str(self.version)
            + ext
        )

class Block:
    
    def __init__(self, lines, name):
        self.lines = lines
        self.name  = name

class NameNotFound(Exception):
    
    def __init__(self, name):
        self.name = name
    
    def __str__(self):
        return self.name
    
    def __repr__(self):
        return self.__str__()

class HaskellDirective(Directive):
    
    def __init__(self, context, *stuff, **more_stuff):
        Directive.__init__(self, *stuff, **more_stuff)
        self.context = context
        
    def run(self):
        cx = self.context

        if len(self.arguments) >= 1:
            source_name = self.arguments[0]
        else:
            source_name = 'Main.hs'

        block_name = (self.options['name']
            if 'name' in self.options
            else None
        )
        after_name = (self.options['after']
            if 'after' in self.options
            else None
        )

        def cmd(s):
            return directives.choice(s, [
                'hold', 'exec', 'done',
                'restart', 'noeval', 'redo',
                'join', 'noecho'
            ])
        
        commands = map(cmd, self.arguments[1:])
        
        if 'restart' in commands:
            cx.file(source_name).restart()

        if 'join' in commands:
            header_html = ''
        else:
            header_html = '''
                <p class="file-header">-- {0} {1} --</p>
                '''.format(
                    escape(source_name),
                    '(cont)' if not cx.file(source_name).empty else ''
                )
        node_header = nodes.raw('', header_html, format='html')
        
        text = u'\n'.join(self.content)
        source_html = haskell_to_html(text,
            line_start = cx.file(source_name).start_line(
                block_name, after_name, 'redo' in commands
            ),
            div = True
        )

        node_source = nodes.raw('', source_html, format='html')
        
        lines = map(str, self.content)
        lines += ['']
        
        if 'redo' in commands:
            cx.file(source_name).redo(lines, block_name)
        elif not ('noeval' in commands):
            cx.file(source_name).feed(lines, block_name, after_name)
        
        result = [ ]

        if 'done' in commands:
            output = cx.file(source_name).compile()
            if len(re.sub('\\s', '', output)) > 0:
                output_html = ('<div class="haskell-output"><p>{0}</p></div>'
                    .format(escape(output)))
            else:
                output_html = ''
            node_output = nodes.raw('', output_html, format='html')
            result = [node_header, node_source, node_output]

        elif 'exec' in commands:
            output = cx.file(source_name).run()
            output_html = ('<div class="haskell-output"><p>{0}</p></div>'
                .format(escape(output)))
            node_output = nodes.raw('', output_html, format='html')
            result = [node_header, node_source, node_output]

        else:
            result = [node_header, node_source]
        
        if 'noecho' in commands:
            return [ ]
        else:
            return result

class GHCIDirective(Directive):

    def __init__(self, context, *stuff, **more_stuff):
        Directive.__init__(self, *stuff, **more_stuff)
        self.context = context
    
    def run(self):
        cx = self.context

        if len(self.arguments) >= 1:
            source_name = self.arguments[0]
        else:
            source_name = None
        
        lines = map(str, self.content)
        
        all_html = ''
        
        for line in lines:
            input_html = haskell_to_html(line, number=False, div=False)
            output_text = cx.ghci(source_name, line)
            
            input_html = '<div class="ghci-input">ghci&gt; {0}</div>'.format(
                input_html
            )
            output_html = '<div class="ghci-output">{0}</div>'.format(
                escape(output_text)
            )
            
            all_html += input_html
            all_html += output_html
        
        all_html = '<div class="ghci-session">{0}</div>'.format(
            all_html
        )
        
        return [nodes.raw('', all_html, format='html')]
    
def remove_blank(str):
    str = re.sub(r'\n$', '', str)
    str = re.sub(r'^\n', '', str)
    return str

structure_css = '''
<style type="text/css">
.file-header {
    color: #999;
    font-size: 12;
    margin: 1.5em 0em 1em 1.0em;
}
.haskell-output {
    white-space: pre;
    font-family: monospace;
    background-color: #fff;
    border: 1px solid #eee;
    margin:  10px 0px 0px 0px;
    padding:  0px 0px 0px  5px;
}
div.haskell {
    background-color: #fff;
    border: 1px solid #eee;
    padding: 0px 0px 0px 5px;
    margin:  5px 0px 0px 0px;
}
.ghci-input {
    white-space: pre;
    font-family: monospace;
    padding: 5px 5px 5px 5px;
}
.ghci-output {
    white-space: pre;
    font-family: monospace;
    padding: 5px 5px 5px 5px;
}
.ghci-session {
    background-color: #fff;
    border: 1px solid #eee;
    margin:  10px 0px 0px 0px;
    padding: 0px 0px 0px 5px;
}
</style>
'''
    
def rst_to_html(source):
    context = HaskellDirectiveContext()
    directives.register_directive('haskell', context.HaskellDirective())
    directives.register_directive('ghci',    context.GHCIDirective())

    parts = publish_parts(
        source,
        writer_name = 'html'
    )
    docutils_css = parts['stylesheet']

    fulltext = docutils_css + haskell_css + structure_css + parts['fragment']
    
    return fulltext

