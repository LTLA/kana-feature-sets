# Precompiled gene sets for kana

Collections of common gene sets for human and mouse, compiled for use in [**kana**](https://github.com/jkanche/kana).
Each gene set collection is expected to provide two files with the same prefix:

- `*_features.csv.gz`, a Gzipped CSV file containing feature identities across all sets.
  This should contain a header with any number of columns, where each column represents a different feature identifier.
  It is expected that the columns will have names reflecting the nature of the identifier, e.g., `ENTREZ`, `SYMBOL` or `ENSEMBL`.
- `*_sets.txt.gz`, a Gzipped text file in GMT-like format where each line represents a single feature set and contains that set's information in tab-delimited fields.
  Like the GMT format, the first field is the set identifier and the second field is the set description.
  However, the third field is the 0-based row index of the first feature in the set.
  The remaining fields on the line (if any) contain diffs of the row indices of all other features in the set, for better compressibility.
 
To identify the feature corresponding to each row index, users should index into the non-header rows of the `*_features.csv.gz` file.
Note that each row is only uniquely defined in terms of the combination of its identifiers, and multiple rows may be present for different combinations of aliases.
Thus, for any given identifier type, duplicates of the same identifier may be present after indexing; these should be removed prior to the enrichment analysis.
