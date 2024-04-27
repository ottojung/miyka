
(define-library
  (miyka root-p)
  (export root/p)
  (import
    (only (scheme base) begin define make-parameter))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin (include-from-path "miyka/root-p.scm")))
    (else (include "root-p.scm"))))
