
(define-library
  (miyka teardown-script-path)
  (export teardown-script:path)
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/teardown-script-path.scm")))
    (else (include "teardown-script-path.scm"))))
