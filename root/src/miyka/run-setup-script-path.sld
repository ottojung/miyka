
(define-library
  (miyka run-setup-script-path)
  (export run-setup-script:path)
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import (only (scheme base) begin lambda))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/run-setup-script-path.scm")))
    (else (include "run-setup-script-path.scm"))))
