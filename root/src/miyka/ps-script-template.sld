
(define-library
  (miyka ps-script-template)
  (export ps-script:template)
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/ps-script-template.scm")))
    (else (include "ps-script-template.scm"))))
