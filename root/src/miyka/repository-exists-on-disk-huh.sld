
(define-library
  (miyka repository-exists-on-disk-huh)
  (export repository:exists-on-disk?)
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import
    (only (miyka repository-possible-ids)
          repository:possible-ids))
  (import
    (only (scheme base) begin lambda not null?))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/repository-exists-on-disk-huh.scm")))
    (else (include "repository-exists-on-disk-huh.scm"))))
