
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
    
    make.ref = function(name, db=self) {
        ref = list(
            db   = db,
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
    
    self = newRClosureTable(list(
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
    class(self) = c('reality', class(self))
    
    outer$reset    = reset
    outer$add.dep  = add.dep
    outer$add.rdep = add.rdep
    outer$del.rdep = del.rdep
    
    outer$delayedAssign = function(name, promise) {
        formulas[[name]] <<- promise
        reset(name)
        promise
    }
    
    outer$`=` = reality.assign
    
    outer$pretend = function(...) {
        copy = reality()
        parent = parent.frame()
        
        for (name in names(formulas)) {
            promise = formulas[[name]]
            old.expr = attr(promise, 'expr')
            old.env  = attr(promise, 'env')
            
            if (!is.null(old.env) && identical(old.env, self)) {
                new.env = copy
            }
            else {
                new.env = old.env
            }
            
            new.promise = make.promise(old.expr, new.env)
            copy$delayedAssign(name, new.promise)
            
            for (dep in dep.table[[name]]) {
                if (identical(dep$db, self)) {
                    dep = make.ref(dep$name, copy)
                }
                copy$add.dep(name, dep)
            }
            
            for (rdep in rdep.table[[name]]) {
                if (identical(rdep$db, self)) {
                    rdep = make.ref(rdep$name, copy)
                }
                copy$add.rdep(name, dep)
            }
        }

        exprs = as.list(substitute(list(...)))[-1L]
        for (name in names(exprs)) {
            expr = exprs[[name]]
            copy$delayedAssign(name, make.promise(expr, copy))
        }
        
        class(copy) = c('pretend', class(copy))
        copy
    }
    
    self
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

print.pretend = function(p) {
    run.interpreter(p)
}

make.promise = function(expr, env) {
    force(expr)
    force(env)

    promise <- function() eval(expr, env)

    attr(promise, 'expr') <- expr
    attr(promise, 'env')  <- env
    
    promise
}

`$.reality` = function(r, name) {
    get(name, envir=r)
}

`$<-.reality` = function(r, name, value) {
    expr = substitute(value)
    env  = parent.frame()

    r$delayedAssign(name, function() eval(expr, env))
    r
}

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
            name <- as.character(deparse(name))
            promise <- make.promise(srvalue, env)

            db$delayedAssign(name, promise)
        },
        function() {
            do.call(`<-`, list(name, rvalue), envir=env)
        }
    )
    invisible(NULL)
}

run.interpreter = function(base.env) {
    options(browserNLdisabled = T)
    with(base.env, browser())
    cat('\n')
}

pretend.env = reality()


