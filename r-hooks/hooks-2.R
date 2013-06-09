
# I can't believe everyone isn't using this!!
library(RObjectTables)

my.symbols = c('a', 'b', 'c')

db = newRClosureTable(list(
    assign = function(name, value) {
        cat(sprintf('%s <- %s\n',
            toString(name),
            as.character(deparse(substitute(value)))
        ))
    },
    
    get = function(name) {
        cat(sprintf('(%s)\n', toString(name)))
        if (name %in% my.symbols) {
            name
        }
        else {
            get(name)
        }
    },
    
    exists = function(name) {
        cat(sprintf('%s?\n', toString(name)))
        if (name %in% my.symbols) {
            T
        }
        else {
            exists(name)
        }
    },
    
    remove = function(name) {
        cat(sprintf('rm %s\n', toString(name)))
    },
    
    objects = function() {
        my.symbols
    }
))

