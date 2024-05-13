
(define-library
  (miyka manifest-path)
  (export manifest:path)
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import (only (scheme base) begin lambda))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/manifest-path.scm")))
    (else (include "manifest-path.scm"))))
