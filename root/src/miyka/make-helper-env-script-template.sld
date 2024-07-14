
(define-library
  (miyka make-helper-env-script-template)
  (export make-helper-env-script:template)
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/make-helper-env-script-template.scm")))
    (else (include "make-helper-env-script-template.scm"))))
