
from __future__ import print_function

import sys
from subprocess import Popen, PIPE

def haskell_to_html(text, line_start=1, number=True, div=True):
    proc = Popen([
            'hscolour',
            '-css',
            '-partial',
            '-nopre'
        ],
        stdin  = PIPE,
        stdout = PIPE
    )
    out, err = proc.communicate(text)
    
    lines = out.split('\n')

    if number:
        for i in range(len(lines)):
            lines[i] = (
                  '<span class="hs-lineno">%3d</span>  ' % (i+line_start)
                + lines[i]
            )
    
    out = '\n'.join(lines)
    
    if div:
        out = '<div class="haskell"><p>{0}</p></div>'.format(
            out
        )
    
    return out

haskell_css = '''
<style type="text/css">
.hs-keyglyph {
    color: #911;
}

.hs-layout {
    color: #911;
}

.hs-comment {
    color: #ccc;
    font-style: italic;
}

.hs-comment a {
    color: #ccc;
    font-style: italic;
}

.hs-str {
    color: teal;
    font-style: italic;
}

.hs-chr {
    color: teal;
}

.hs-keyword {
    color: #000;
    font-weight: bold;
}

.hs-conid {
    color: #039;
}

.hs-varid {
    color: #000;
}

.hs-conop {
    color: #900;
}

.hs-varop {
    color: #900;
}

.hs-num {
    color: #0aa;
}

.hs-cpp {
    color: #900;
}

.hs-sel {
    color: #900;
}

.hs-definition {
    color: teal;
}

.hs-lineno {
    color: #aaa;
}

div.haskell {
    white-space: pre;
    font-family: monospace;
}
</style>
'''

