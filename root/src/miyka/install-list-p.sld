
(define-library
  (miyka install-list-p)
  (export install-list/p)
  (import
    (only (scheme base) begin define make-parameter))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/install-list-p.scm")))
    (else (include "install-list-p.scm"))))
