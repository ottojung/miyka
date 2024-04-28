
(define-library
  (miyka image-tag)
  (export image:tag)
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import
    (only (miyka check-tag-name) check-tag-name))
  (import (only (scheme base) begin lambda))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin (include-from-path "miyka/image-tag.scm")))
    (else (include "image-tag.scm"))))
