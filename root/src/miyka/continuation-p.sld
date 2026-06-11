
(define-library
  (miyka continuation-p)
  (export continuation/p)
  (import
    (only (scheme base) begin define make-parameter))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin (include-from-path "miyka/continuation-p.scm")))
    (else (include "continuation-p.scm"))))
