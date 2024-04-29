
(define-library
  (miyka container-name)
  (export container:name)
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import (only (scheme base) begin lambda))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/container-name.scm")))
    (else (include "container-name.scm"))))
