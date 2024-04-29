
(define-library
  (miyka configuration-path)
  (export configuration:path)
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import (only (scheme base) begin lambda))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/configuration-path.scm")))
    (else (include "configuration-path.scm"))))
