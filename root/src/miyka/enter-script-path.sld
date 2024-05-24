
(define-library
  (miyka enter-script-path)
  (export enter-script:path)
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import (only (scheme base) begin lambda))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/enter-script-path.scm")))
    (else (include "enter-script-path.scm"))))
