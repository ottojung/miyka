
(define-library
  (miyka docker-file-template)
  (export docker-file-template)
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/docker-file-template.scm")))
    (else (include "docker-file-template.scm"))))
