
(define-library
  (miyka repository-exists-in-docker-huh)
  (export repository:exists-in-docker?)
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import
    (only (miyka image-exists-huh) image:exists?))
  (import
    (only (miyka dockerfile-image) dockerfile:image))
  (import (only (scheme base) begin lambda))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/repository-exists-in-docker-huh.scm")))
    (else (include "repository-exists-in-docker-huh.scm"))))
