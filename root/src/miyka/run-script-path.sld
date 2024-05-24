
(define-library
  (miyka run-script-path)
  (export run-script:path)
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import (only (scheme base) begin lambda))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/run-script-path.scm")))
    (else (include "run-script-path.scm"))))
