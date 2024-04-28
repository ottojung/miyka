
(define-library
  (miyka check-tag-name)
  (export check-tag-name)
  (import (only (euphrates raisu-fmt) raisu-fmt))
  (import
    (only (scheme base)
          =
          begin
          define
          quote
          string-length
          when))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/check-tag-name.scm")))
    (else (include "check-tag-name.scm"))))
