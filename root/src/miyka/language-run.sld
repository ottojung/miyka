
(define-library
  (miyka language-run)
  (export language:run)
  (import
    (only (euphrates random-variable-name)
          random-variable-name))
  (import
    (only (euphrates system-star-exit-code)
          system*/exit-code))
  (import
    (only (miyka container-name) container:name))
  (import
    (only (scheme base)
          begin
          define
          string-append
          values))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/language-run.scm")))
    (else (include "language-run.scm"))))
