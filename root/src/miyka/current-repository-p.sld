
(define-library
  (miyka current-repository-p)
  (export current-repository/p)
  (import
    (only (scheme base) begin define make-parameter))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/current-repository-p.scm")))
    (else (include "current-repository-p.scm"))))
