
(define-library
  (miyka repository-image)
  (export repository:image)
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
             (include-from-path "miyka/repository-image.scm")))
    (else (include "repository-image.scm"))))
