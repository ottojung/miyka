
(define-library
  (miyka repository-path)
  (export repository:path)
  (import
    (only (euphrates properties) define-property))
  (import (only (scheme base) begin))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/repository-path.scm")))
    (else (include "repository-path.scm"))))
