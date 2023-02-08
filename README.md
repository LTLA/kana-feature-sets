# Precompiled gene sets for kana

Collections of common gene sets for human and mouse, compiled for use in [**kana**](https://github.com/jkanche/kana).
Each gene set collection is expected to provide two files with the same prefix:

- `*_features.csv.gz`, a Gzipped CSV file containing feature identities across all sets.
  This should contain a header with any number of columns, where each column represents a different feature identifier.
  It is expected that the columns will have names reflecting the nature of the identitier, e.g., `ENTREZ`, `SYMBOL` or `ENSEMBL`.
- `*_sets.txt.gz`, a Gzipped text file in GMT-like format where each line represents a single feature set and contains that set's information in tab-delimited fields.
  Like the GMT format, the first field is the set identifier and the second field is the set description.
  However, the third field is the 0-based row index of the first feature in the set, where indices are relative to the non-header rows in the `*_features.csv.gz` file.
  The remaining fields on the line (if any) contain diffs of the row indices of all other features in the set, for better compressibility.
