
(define-library
  (miyka repository-name)
  (export repository:name)
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import
    (only (miyka check-repo-name) check-repo-name))
  (import (only (scheme base) begin lambda))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/repository-name.scm")))
    (else (include "repository-name.scm"))))
