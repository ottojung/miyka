
(define-library
  (miyka relative-path-script-path)
  (export relative-path-script:path)
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/relative-path-script-path.scm")))
    (else (include "relative-path-script-path.scm"))))
