
forwardBackward = function (HMM, obs) 
{
    if ((class(HMM) != "HMMFitClass") && (class(HMM) != "HMMClass")) 
        stop("class(HMM) must be 'HMMClass' or 'HMMFitClass'\n")
    if (class(HMM) == "HMMFitClass") 
        HMM <- HMM$HMM
    if (length(obs) < 1) 
        stop("'obs' needs to contain at least a single element!")
    if (is.data.frame(obs)) {
        dimObs <- dim(obs)[2]
        if (dimObs == 1) 
            obs <- obs[, 1]
        else obs <- as.matrix(obs[, 1:dimObs])
    }
    HMM <- setStorageMode(HMM)
    maListe <- TransfListe(HMM$distribution, obs)
    Res1 <- .Call("RLogforwardbackward", HMM, maListe$Zt)
    names(Res1) <- c("Alpha", "Beta", "Gamma", "Xsi", "Rho", 
        "LLH")
    if (!is.list(obs)) {
        Res1$Alpha <- t(Res1$Alpha[[1]])
        Res1$Beta <- t(Res1$Beta[[1]])
        Res1$Gamma <- t(Res1$Gamma[[1]])
        Res1$Xsi <- Res1$Xsi[[1]]
        Res1$Xsi[[length(Res1$Xsi)]] <- NaN
        Res1$Rho <- Res1$Rho[[1]]
        Res1$LLH <- Res1$LLH[[1]]
    }
    else {
        for (n in 1:length(obs)) {
            Res1$Alpha[[n]] <- t(Res1$Alpha[[n]])
            Res1$Beta[[n]] <- t(Res1$Beta[[n]])
            Res1$Gamma[[n]] <- t(Res1$Gamma[[n]])
            Res1$Xsi[[n]][length(Res1$Xsi[[n]])] <- NaN
        }
    }
    return(Res1)
}

