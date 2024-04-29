
(define-library
  (miyka dockerfile-image)
  (export dockerfile:image)
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
             (include-from-path "miyka/dockerfile-image.scm")))
    (else (include "dockerfile-image.scm"))))
