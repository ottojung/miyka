
(define-library
  (miyka run-sync-script-path)
  (export run-sync-script:path)
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import (only (scheme base) begin lambda))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/run-sync-script-path.scm")))
    (else (include "run-sync-script-path.scm"))))
