
(define-library
  (miyka start-script-template)
  (export start-script:template)
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/start-script-template.scm")))
    (else (include "start-script-template.scm"))))
