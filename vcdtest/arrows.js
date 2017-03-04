
var counter = 0
function luid() {
    counter++
    return 'i'+counter
}

function MovableArrow(parent, source, target, options) {
    var sourceGhostID = luid();
    var targetGhostID = luid();
    var sourceGhost = $('<div>', {id:sourceGhostID,style:'position:absolute;'})
    var targetGhost = $('<div>', {id:targetGhostID,style:'position:absolute;'})
    parent.append(sourceGhost)
    parent.append(targetGhost)
    
    jsPlumb.connect($.extend({source:sourceGhostID,target:targetGhostID}, options))
    
    var that = {
        source: source,
        target: target,
        
        sourceGhost: sourceGhost,
        targetGhost: targetGhost,
        
        update: function() {
            that.matchPair(that.sourceGhost, that.source);
            that.matchPair(that.targetGhost, that.target);
        },
        
        matchPair: function(from, to) {
            oldOffset = from.offset()
            newOffset = to.offset()
            oldWidth = from.width()
            newWidth = to.width()
            oldHeight = from.height()
            newHeight = to.height()
            
            if (
                oldOffset.top  != newOffset.top ||
                oldOffset.left != newOffset.left ||
                oldWidth != newWidth ||
                oldHeight != newHeight
            )
            {
                from.offset(newOffset)
                from.width(newWidth)
                from.height(newHeight)
                
                jsPlumb.repaint(from)
            }
        }
    }
    return that
}

