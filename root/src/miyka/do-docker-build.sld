
(define-library
  (miyka do-docker-build)
  (export do-docker-build)
  (import (only (scheme base) begin define values))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/do-docker-build.scm")))
    (else (include "do-docker-build.scm"))))
