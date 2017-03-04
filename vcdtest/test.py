
import json
from bisect import bisect

with open('./dump.json') as hl:
    dump = json.load(hl)

class Signal:
    def __init__(self, dump_sig):
        self.name = dump_sig['nets'][0]['hier'] + '.' + dump_sig['nets'][0]['name']
        self.changes = dump_sig['tv']
        
    def __repr__(self):
        return '%s = %s' % (self.name, self.changes)
    
    def time_at(self, k):
        if k < 0: return -1e300
        elif k >= len(self.changes): return 1e300
        return self.changes[k][0]
    
    def value_at(self, k):
        if k < 0: return 'x'
        elif k >= len(self.changes): return 'x'
        return self.changes[k][1]
    
class PointedSignal:
    def __init__(self, signal):
        self.signal = signal
        self.times  = [p[0] for p in self.signal.changes]
        self.point = 0
        
    def jump_to(self, time):
        self.point = bisect(self.times, time)-1
        
    def crawl_to(self, time):
        if self.signal.time_at(self.point) < time:
            self.advance_to(time)
        else:
            self.retreat_to(time)
        
    def advance_to(self, time):
        while self.signal.time_at(self.point+1) <= time:
            self.point += 1
            
    def retreat_to(self, time):
        while self.signal.time_at(self.point) > time:
            self.point -= 1
            
    @property
    def value(self):
        return self.signal.value_at(self.point)
    
    @property
    def name(self):
        return self.signal.name
        
class PointedSignalSet:
    def __init__(self, signals):
        self.signals = signals
        self.time = 0
        
    def step(self):
        self.time += 1
        for sig in self.signals:
            sig.advance_to(self.time)
            
    def back(self):
        self.time -= 1
        for sig in self.signals:
            sig.retreat_to(self.time)
            
    def jump(self, time):
        self.time = time
        for sig in self.signals:
            sig.jump_to(self.time)

    @property
    def snapshot(self):
        return dict([
            (sig.name, sig.value) for sig in self.signals
        ])
        
signals = [Signal(dump[k]) for k in dump]

psignals = [PointedSignal(sig) for sig in signals]
pset = PointedSignalSet(psignals)

def scan():
    print '%3d: %s' % (pset.time, pset.snapshot)
        
scan()

for _ in range(10):
    pset.step()
    scan()

pset.jump(3)
scan()

