
(define-library
  (miyka enter-script-template)
  (export enter-script:template)
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/enter-script-template.scm")))
    (else (include "enter-script-template.scm"))))
