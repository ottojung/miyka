
(define-library
  (miyka log-directory-path)
  (export log-directory:path)
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import (only (scheme base) begin lambda))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/log-directory-path.scm")))
    (else (include "log-directory-path.scm"))))
