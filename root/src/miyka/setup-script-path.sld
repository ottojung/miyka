
(define-library
  (miyka setup-script-path)
  (export setup-script:path)
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import (only (scheme base) begin lambda))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/setup-script-path.scm")))
    (else (include "setup-script-path.scm"))))
