
(define-library
  (miyka repository-id)
  (export repository:id)
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import
    (only (miyka repository-work-directory)
          repository:work-directory))
  (import (only (scheme base) begin lambda))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/repository-id.scm")))
    (else (include "repository-id.scm"))))
