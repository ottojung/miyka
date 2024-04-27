
(define-library
  (miyka docker-file-name)
  (export docker-file-name)
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/docker-file-name.scm")))
    (else (include "docker-file-name.scm"))))
