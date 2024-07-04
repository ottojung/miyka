
(define-library
  (miyka miyka-version)
  (export miyka:version)
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/miyka-version.scm")))
    (else (include "miyka-version.scm"))))
