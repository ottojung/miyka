
(define-library
  (miyka bin-path)
  (export bin:path)
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import (only (scheme base) begin lambda))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin (include-from-path "miyka/bin-path.scm")))
    (else (include "bin-path.scm"))))
