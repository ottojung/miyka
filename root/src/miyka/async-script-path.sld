
(define-library
  (miyka async-script-path)
  (export async-script:path)
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import (only (scheme base) begin lambda))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/async-script-path.scm")))
    (else (include "async-script-path.scm"))))
