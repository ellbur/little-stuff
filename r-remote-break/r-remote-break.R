
foo = function() {
    callCC(function(cc) {
        while (1) {
            print("Beginning loop")
            delayedAssign('force.next', {next})
            do.next = function() force(force.next)
            
            cc(do.next)
        }
    })
}

