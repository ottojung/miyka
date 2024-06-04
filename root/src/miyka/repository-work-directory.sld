
(define-library
  (miyka repository-work-directory)
  (export repository:work-directory)
  (import
    (only (euphrates properties) define-property))
  (import (only (scheme base) begin))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/repository-work-directory.scm")))
    (else (include "repository-work-directory.scm"))))
