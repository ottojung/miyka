
(define-library
  (miyka start-script-path)
  (export start-script:path)
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import (only (scheme base) begin lambda))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/start-script-path.scm")))
    (else (include "start-script-path.scm"))))
