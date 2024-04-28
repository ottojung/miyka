
(define-library
  (miyka repository-image-tag)
  (export repository:image:tag)
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
               "miyka/repository-image-tag.scm")))
    (else (include "repository-image-tag.scm"))))
