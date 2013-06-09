
# I can't believe everyone isn't using this!!
library(RObjectTables)

db = newRClosureTable(list(
    assign = function(name, value) {
        cat(sprintf('%s <- %s\n',
            toString(name),
            toString(value)
        ))
    },
    
    get = function(name) {
        cat(sprintf('(%s)\n', toString(name)))
        name
    },
    
    exists = function(name) {
        cat(sprintf('%s?\n', toString(name)))
        T
    },
    
    remove = function(name) {
        cat(sprintf('rm %s\n', toString(name)))
    },
    
    objects = function() {
        list()
    }
))

print(db)

with(db, x)

