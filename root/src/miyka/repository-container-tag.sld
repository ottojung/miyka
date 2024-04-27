
(define-library
  (miyka repository-container-tag)
  (export repository:container-tag)
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import
    (only (miyka repository-name) repository:name))
  (import
    (only (scheme base) begin lambda string-append))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/repository-container-tag.scm")))
    (else (include "repository-container-tag.scm"))))
