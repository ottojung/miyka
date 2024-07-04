
(define-library
  (miyka versionfile-path)
  (export versionfile:path)
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/versionfile-path.scm")))
    (else (include "versionfile-path.scm"))))
