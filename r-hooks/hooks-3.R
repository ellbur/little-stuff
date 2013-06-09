
# I can't believe everyone isn't using this!!
library(RObjectTables)

working.refs = list()

echo = function(x) {
	cat(sprintf('%s = \n', as.character(deparse(substitute(x)))))
	print(x)
}

reality = function() {
    parent = parent.frame()
    outer = new.env(parent = parent)

    formulas = list()
    valid = list()
    values = list()
    
    make.ref = function(name) {
        ref = list(
            db   = self,
            name = name
        )
        class(ref) = 'ref'
        ref
    }
    
    dep.table = list()
    rdep.table = list()
    
    propagate = function(name) {
        if (is.null(valid[[name]]) || !valid[[name]]) {
        }
        else {
            for (ref in rdep.table[[name]]) {
                ref$db$reset(ref$name)
            }
        }
    }
    
    reset = function(name) {
        propagate(name)
        valid[[name]] <<- F
    }
    
    add.dep = function(name, ref) {
        dep.table[[name]] <<- c(list(ref), dep.table[[name]])
    }
    
    add.rdep = function(name, ref) {
        rdep.table[[name]] <<- c(list(ref), rdep.table[[name]])
    }
    
    del.rdep = function(name, ref) {
        rdep.table[[name]] <<- setdiff(rdep.table[[name]], list(ref))
    }
    
    ptr = newRClosureTable(list(
        assign = function(name, value) {
            force(value)
            formulas[[name]] <<- function() value
            reset(name)
        },
        get = function(name) {
            if (is.null(formulas[[name]])) {
                return(tryCatch(
                    get(name, outer),
                    error = function(e) getUnbound()
                ))
            }

            this.ref = make.ref(name)
            for (ref in working.refs) {
                ref$db$add.dep(ref$name, this.ref)
            }
            
            if (is.null(valid[[name]]) || !valid[[name]]) {
                old.deps <<- dep.table[[name]]
                dep.table[[name]] <<- list()

                working.refs <<- c(list(this.ref), working.refs)
                
                values[[name]] <<- formulas[[name]]()

                working.refs <<- working.refs[-1L]
                
                lost.deps = setdiff(old.deps, dep.table[[name]])
                for (ref in lost.deps) {
                    ref$db$del.rdep(ref$name, this.ref)
                }
                
                gained.deps = setdiff(dep.table[[name]], old.deps)
                for (ref in gained.deps) {
                    ref$db$add.rdep(ref$name, this.ref)
                }
                
                valid[[name]] <<- T
            }
            
            values[[name]]
        },
        exists = function(name) {
            !is.null(valid[[name]]) || exists(name, parent)
        },
        remove = function(name) {
            # TODO: this
        },
        objects = function(name) {
            names(valid)
        }
    ))
    class(ptr) = c('reality', class(ptr))
    
    attr(ptr, 'delayedAssign') = (
        function(name, promise) {
            formulas[[name]] <<- promise
            reset(name)
            promise
        }
    )
    
    self = list(
        ptr      = ptr,
        reset    = reset,
        add.dep  = add.dep,
        add.rdep = add.rdep,
        del.rdep = del.rdep
    )
    class(self) = 'realptr'
    
    ptr
}

as.character.ref = function(ref) {
    sprintf('%s[%s]', as.character(ref$db), as.character(ref$name))
}

as.character.realptr = function(rptr) {
    as.character(rptr$ptr)
}

as.character.UserDefinedDatabase = function(db) {
    "db"
}

`$.reality` = function(r, name) {
    get(name, envir=r)
}

`$<-.reality` = function(r, name, value) {
    expr = substitute(value)
    env  = parent.frame()

    attr(r, 'delayedAssign')(
        name, function() eval(expr, env)
    )

    r
}

r = reality()

with.db = function(env, func1, func2) {
    if ('reality' %in% class(env)) {
        func1(env)
    }
    else {
        func2()
    }
}

reality.assign = function(name, rvalue) {
    env     <- parent.frame()
    name    <- substitute(name)
    srvalue <- substitute(rvalue)
    
    with.db(env,
        function(db) {
            name  <- as.character(deparse(name))
            promise <- function() eval(srvalue, env)

            attr(db, 'delayedAssign')(name, promise)
            alist(x=)$x
        },
        function() {
            do.call(`<-`, list(name, rvalue), envir=env)
        }
    )
}

with(r, `=` <- reality.assign)

run.interpreter = function(base.env) {
    options(browserNLdisabled = T)
    with(base.env, browser())
}

