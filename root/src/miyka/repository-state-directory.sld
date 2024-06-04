
(define-library
  (miyka repository-state-directory)
  (export repository:state-directory)
  (import
    (only (euphrates properties) define-property))
  (import (only (scheme base) begin))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/repository-state-directory.scm")))
    (else (include "repository-state-directory.scm"))))
