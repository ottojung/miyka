
(define-library
  (miyka configuration-template)
  (export configuration:template)
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/configuration-template.scm")))
    (else (include "configuration-template.scm"))))
