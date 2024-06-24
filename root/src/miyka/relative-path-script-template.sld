
(define-library
  (miyka relative-path-script-template)
  (export relative-path-script:template)
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/relative-path-script-template.scm")))
    (else (include "relative-path-script-template.scm"))))
