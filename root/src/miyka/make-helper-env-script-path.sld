
(define-library
  (miyka make-helper-env-script-path)
  (export make-helper-env-script:path)
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/make-helper-env-script-path.scm")))
    (else (include "make-helper-env-script-path.scm"))))
