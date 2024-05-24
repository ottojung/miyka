
(define-library
  (miyka get-guix-executable)
  (export get-guix-executable)
  (import (only (euphrates raisu-fmt) raisu-fmt))
  (import
    (only (miyka guix-executable-env-variable-name)
          guix-executable-env-variable-name))
  (import
    (only (miyka guix-executable-p)
          guix-executable/p))
  (import
    (only (scheme base) begin define or quote))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/get-guix-executable.scm")))
    (else (include "get-guix-executable.scm"))))
