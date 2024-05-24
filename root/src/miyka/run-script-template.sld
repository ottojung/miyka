
(define-library
  (miyka run-script-template)
  (export run-script:template)
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/run-script-template.scm")))
    (else (include "run-script-template.scm"))))
