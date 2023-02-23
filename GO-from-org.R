GO.from.org <- function(orgdb, prefix) {
    mappings <- select(orgdb, keytype="GO", keys=keys(orgdb, "GO"), columns=c("ENTREZID", "SYMBOL", "ENSEMBL"))

    all.gene.info <- DataFrame(mappings[,c("ENTREZID", "SYMBOL", "ENSEMBL")])
    for (x in colnames(all.gene.info)) {
        col <- all.gene.info[[x]] 
        all.gene.info[[x]][is.na(col)] <- ""
    }
    genes <- unique(all.gene.info)
    m <- match(all.gene.info, genes)

    con <- gzfile(paste0(prefix, "_features.csv.gz"), open="wb")
    write.csv(data.frame(ENTREZ=genes$ENTREZID, SYMBOL=genes$SYMBOL, ENSEMBL=genes$ENSEMBL), file=con, quote=FALSE, row.names=FALSE)
    close(con)

    # Compressing by storing diffs instead of the full numbers.
    library(BiocParallel)
    output <- split(m, mappings$GO)
    output <- bplapply(output, function(x) {
        current <- unique(sort(x))
        contents <- c(current[1] - 1L, diff(current)) # zero based.
        paste(contents, collapse="\t")
    }, BPPARAM=MulticoreParam())

    # Saving the names and descriptions.
    library(GO.db)
    info <- select(GO.db, keys=names(output), column="TERM")
    payload <- sprintf("%s\t%s\t%s", names(output), info$TERM[match(names(output), info$GOID)], output)

    con <- gzfile(paste0(prefix, "_sets.txt.gz"), open="wb")
    write(payload, file=con)
    close(con)

    # Emitting relevant session information.
    print(metadata(orgdb))
}

library(org.Hs.eg.db)
GO.from.org(org.Hs.eg.db, "human-GO")

library(org.Mm.eg.db)
GO.from.org(org.Mm.eg.db, "mouse-GO")

library(org.Dm.eg.db)
GO.from.org(org.Dm.eg.db, "fly-GO")

library(org.Ce.eg.db)
GO.from.org(org.Ce.eg.db, "worm-GO")

library(org.Rn.eg.db)
GO.from.org(org.Rn.eg.db, "rat-GO")

library(org.Pt.eg.db)
GO.from.org(org.Pt.eg.db, "chimp-GO")

library(org.Dr.eg.db)
GO.from.org(org.Dr.eg.db, "zebrafish-GO")
