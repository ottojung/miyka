
(define-library
  (miyka container-mutable-huh)
  (export container:mutable?)
  (import
    (only (euphrates properties) define-property))
  (import (only (scheme base) begin))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/container-mutable-huh.scm")))
    (else (include "container-mutable-huh.scm"))))
