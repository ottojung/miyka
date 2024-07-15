
(define-library
  (miyka repository-exists-on-disk-huh)
  (export repository:exists-on-disk?)
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import
    (only (miyka get-repositories-id-map)
          get-repositories-id-map))
  (import
    (only (miyka repository-name) repository:name))
  (import
    (only (scheme base)
          assoc
          begin
          define
          lambda
          not))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/repository-exists-on-disk-huh.scm")))
    (else (include "repository-exists-on-disk-huh.scm"))))
