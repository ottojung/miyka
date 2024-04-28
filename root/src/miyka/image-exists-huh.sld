
(define-library
  (miyka image-exists-huh)
  (export image:exists?)
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import
    (only (euphrates run-syncproc) run-syncproc))
  (import (only (miyka image-tag) image:tag))
  (import
    (only (scheme base)
          =
          begin
          current-error-port
          current-output-port
          define
          lambda
          parameterize))
  (import
    (only (scheme file) call-with-output-file))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/image-exists-huh.scm")))
    (else (include "image-exists-huh.scm"))))
