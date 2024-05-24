
(define-library
  (miyka run-async-script-path)
  (export run-async-script:path)
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import (only (scheme base) begin lambda))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/run-async-script-path.scm")))
    (else (include "run-async-script-path.scm"))))
