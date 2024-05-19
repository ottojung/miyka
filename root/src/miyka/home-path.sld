
(define-library
  (miyka home-path)
  (export home:path)
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import (only (scheme base) begin lambda))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin (include-from-path "miyka/home-path.scm")))
    (else (include "home-path.scm"))))
