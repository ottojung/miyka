
(define-library
  (miyka init-script-path)
  (export init-script:path)
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import (only (scheme base) begin lambda))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/init-script-path.scm")))
    (else (include "init-script-path.scm"))))
