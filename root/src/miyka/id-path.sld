
(define-library
  (miyka id-path)
  (export id:path)
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import (only (scheme base) begin lambda))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin (include-from-path "miyka/id-path.scm")))
    (else (include "id-path.scm"))))
