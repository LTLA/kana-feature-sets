library(org.Hs.eg.db)
prefix <- paste0("human-GO_", packageVersion("org.Hs.eg.db"))
mappings <- select(org.Hs.eg.db, keytype="GO", keys=keys(org.Hs.eg.db, "GO"), columns=c("ENTREZID", "SYMBOL", "ENSEMBL"))

all.gene.info <- DataFrame(mappings[,c("ENTREZID", "SYMBOL", "ENSEMBL")])
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
con <- gzfile(paste0(prefix, "_extra.txt.gz"), open="wb")
write.csv(as.data.frame(metadata(org.Hs.eg.db)), file=con, quote=FALSE, row.names=FALSE)
close(con)
