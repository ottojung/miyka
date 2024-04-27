
(define-library
  (miyka repository-exists-on-disk-huh)
  (export repository:exists-on-disk?)
  (import
    (only (euphrates file-or-directory-exists-q)
          file-or-directory-exists?))
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import
    (only (miyka repository-path) repository:path))
  (import (only (scheme base) begin lambda))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/repository-exists-on-disk-huh.scm")))
    (else (include "repository-exists-on-disk-huh.scm"))))
