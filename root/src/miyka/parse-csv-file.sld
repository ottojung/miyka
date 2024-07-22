
(define-library
  (miyka parse-csv-file)
  (export parse-csv-file)
  (import (only (euphrates read-lines) read/lines))
  (import
    (only (euphrates string-split-simple)
          string-split/simple))
  (import
    (only (scheme base)
          begin
          car
          cdr
          cons
          define
          lambda
          map
          string->symbol
          values))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/parse-csv-file.scm")))
    (else (include "parse-csv-file.scm"))))
