
(define-library
  (miyka ps-script-path)
  (export ps-script:path)
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/ps-script-path.scm")))
    (else (include "ps-script-path.scm"))))
