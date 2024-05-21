
(define-library
  (miyka state-directory-path)
  (export state-directory:path)
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import (only (scheme base) begin lambda))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/state-directory-path.scm")))
    (else (include "state-directory-path.scm"))))
