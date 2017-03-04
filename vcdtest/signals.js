
function VCDSignalSet(vcdData) {
    var signals = [ ]
    for (i in vcdData) {
        var sweep = vcdData[i]
        var changes = sweep.tv;
        var name = sweep.nets[0].hier + "." + stripBits(sweep.nets[0].name);
        var width = sweep.nets[0].size;
        
        signals.push(PointedSignal(Signal(name, width, changes)))
    }
    
    return PointedSignalSet(signals)
}

function stripBits(name) {
    var bIndex = name.indexOf('[')
    if (bIndex < 0) return name;
    return name.substring(0, bIndex);
}

function Signal(name, width, changes) {
    var that = {
        name: name,
        changes: changes,
        width: width,
        times: changes.map(function (c) {
            return c[0]
        }),
        values: changes.map(function (c) {
            return c[1]
        }),
        
        time_at: function(k) {
            if (k < 0) return -1e300;
            if (k >= that.times.length) return 1e300;
            return that.times[k]
        },
        
        value_at: function(k) {
            if (k < 0) return that.values[0];
            if (k >= that.times.length) return that.values[that.times.length-1];
            return that.values[k]
        }
    }
    return that
}

function PointedSignal(signal) {
    var that = {
        signal: signal,
        name: signal.name,
        width: signal.width,
        point: 0,
        
        advance_to: function(time) {
            while (that.signal.time_at(that.point+1) <= time) {
                that.point++
            }
        },
        
        retreat_to: function(time) {
            while (that.signal.time_at(that.point) > time) {
                that.point--
            }
        },
        
        value: function() {
            return that.signal.value_at(that.point)
        }
    }
    return that
}

function PointedSignalSet(signals) {
    var that = {
        time: 0,
        signals: signals,
        names: signals.map(function(sig) { return sig.name; }),
        startTime: Math.min.apply(null, signals.map(function (sig) {
            return sig.signal.times[0]
        })),
        endTime: Math.max.apply(null, signals.map(function (sig) {
            return sig.signal.times[sig.signal.times.length-1]
        })),
        
        next: function() {
            that.time++
            that.signals.map(function(sig) {
                sig.advance_to(that.time)
            })
        },
        
        prev: function() {
            that.time--
            that.signals.map(function(sig) {
                sig.retreat_to(that.time)
            })
        },
        
        snapshot: function() {
            snap = [ ]
            for (i in that.signals) {
                sig = that.signals[i];
                snap[sig.name] = extend(sig.value(), sig.width);
            }
            return snap
        }
    }
    return that
}

