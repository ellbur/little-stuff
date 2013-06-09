
from subprocess import Popen, PIPE, STDOUT
from glob import glob

#run.rstweaver = function(text) {
#    sink('output.txt')
#    result = eval(text, env=.GlobalEnv)
#    print(result)
#    sink()
#}

def setup():
    proc = Popen(
        ['dmtcp_checkpoint', 'Rscript', '-'],
        stdin  = PIPE
    )
    proc.communicate(
    '''
        system('dmtcp_command cb')
    '''
    )
    
    snap = glob('ckpt_*')[0]
    Popen(['mv', snap, 'save_R']).wait()

def run(input):
    proc = Popen(
        ['dmtcp_restart', 'save_R'],
        stdout = PIPE,
        stderr = STDOUT,
        stdin  = PIPE
    )
    proc.communicate(
    '''
        run.rstweaver({0})
        system('dmtcp_command cb')
    '''.format(repr(input))
    )
    snap = glob('ckpt_*')[0]
    Popen(['mv', snap, 'save_R']).wait()
    
    with open('output.txt') as hl:
        output = hl.read()
        
    return output

