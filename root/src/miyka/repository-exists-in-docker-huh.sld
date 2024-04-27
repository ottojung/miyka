
(define-library
  (miyka repository-exists-in-docker-huh)
  (export repository:exists-in-docker?)
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import
    (only (euphrates run-syncproc) run-syncproc))
  (import
    (only (miyka repository-container-tag)
          repository:container-tag))
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
             (include-from-path
               "miyka/repository-exists-in-docker-huh.scm")))
    (else (include "repository-exists-in-docker-huh.scm"))))
