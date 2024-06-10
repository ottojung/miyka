
(define-library
  (miyka configuration-directory-path)
  (export configuration-directory:path)
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import (only (scheme base) begin lambda))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/configuration-directory-path.scm")))
    (else (include "configuration-directory-path.scm"))))
