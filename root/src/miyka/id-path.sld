
(define-library
  (miyka id-path)
  (export id:path)
  (import
    (only (euphrates properties) define-property))
  (import (only (scheme base) begin))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin (include-from-path "miyka/id-path.scm")))
    (else (include "id-path.scm"))))
