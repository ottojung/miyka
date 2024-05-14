
(define-library
  (miyka interpretation-p)
  (export interpretation/p)
  (import
    (only (scheme base) begin define make-parameter))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/interpretation-p.scm")))
    (else (include "interpretation-p.scm"))))
