
#include <R.h>
#include <Rinternals.h>

int main() {
    SEXP obj;
    SEXP stream;
    SEXP op, args;
    
    obj = R_NilValue;
    
    PROTECT(op = mkChar("file"));
    PROTECT(args = list5(
        PROTECT(mkChar("./data.Rdata")),
        PROTECT(mkChar("w")),
        PROTECT(ScalarLogical(1)),
        PROTECT(mkChar("native.enc")),
        PROTECT(ScalarLogical(0))
    ));
    PROTECT(stream = do_url(R_NilValue, op, args, R_NilValue));
    
    R_serialize(
        obj,
        stream,
        PROTECT(ScalarLogical(1)),
        R_NilValue,
        R_NilValue,
        PROTECT(mkChar("base"))
    );
    
    do_close(
        R_NilValue,
        PROTECT(mkChar("close")),
        PROTECT(list2(
            stream,
            PROTECT(mkChar("rw"))
        ))
    );
    
    UNPROTECT(13);
}

