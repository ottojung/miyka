
(define-library
  (miyka guix-describe)
  (export guix-describe)
  (import (only (euphrates raisu-fmt) raisu-fmt))
  (import
    (only (euphrates run-syncproc) run-syncproc))
  (import
    (only (scheme base)
          =
          begin
          current-output-port
          define
          lambda
          parameterize
          quote
          unless))
  (import
    (only (scheme file) call-with-output-file))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/guix-describe.scm")))
    (else (include "guix-describe.scm"))))
