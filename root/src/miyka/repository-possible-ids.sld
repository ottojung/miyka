
(define-library
  (miyka repository-possible-ids)
  (export repository:possible-ids)
  (import
    (only (euphrates properties) define-property))
  (import (only (scheme base) begin))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/repository-possible-ids.scm")))
    (else (include "repository-possible-ids.scm"))))
