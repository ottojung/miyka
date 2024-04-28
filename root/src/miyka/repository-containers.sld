
(define-library
  (miyka repository-containers)
  (export repository:containers)
  (import
    (only (euphrates properties) define-property))
  (import (only (scheme base) begin))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/repository-containers.scm")))
    (else (include "repository-containers.scm"))))
