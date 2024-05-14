
(define-library
  (miyka init-script-template)
  (export init-script:template)
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/init-script-template.scm")))
    (else (include "init-script-template.scm"))))
