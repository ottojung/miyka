
(define-library
  (miyka check-repo-name)
  (export check-repo-name)
  (import (only (euphrates raisu-fmt) raisu-fmt))
  (import
    (only (scheme base)
          =
          begin
          define
          quote
          string-length
          values
          when))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/check-repo-name.scm")))
    (else (include "check-repo-name.scm"))))
