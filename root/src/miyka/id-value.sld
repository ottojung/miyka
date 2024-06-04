
(define-library
  (miyka id-value)
  (export id:value)
  (import
    (only (euphrates properties) define-property))
  (import (only (scheme base) begin))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin (include-from-path "miyka/id-value.scm")))
    (else (include "id-value.scm"))))
