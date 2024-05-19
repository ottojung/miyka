
(define-library
  (miyka work-directory-path)
  (export work-directory:path)
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import (only (scheme base) begin lambda))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/work-directory-path.scm")))
    (else (include "work-directory-path.scm"))))
