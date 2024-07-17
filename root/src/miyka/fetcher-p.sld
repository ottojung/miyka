
(define-library
  (miyka fetcher-p)
  (export fetcher/p)
  (import
    (only (scheme base) begin define make-parameter))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin (include-from-path "miyka/fetcher-p.scm")))
    (else (include "fetcher-p.scm"))))
