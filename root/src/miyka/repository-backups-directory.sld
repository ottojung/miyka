
(define-library
  (miyka repository-backups-directory)
  (export repository:backups-directory)
  (import
    (only (euphrates append-posix-path)
          append-posix-path))
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import
    (only (miyka repository-path) repository:path))
  (import (only (scheme base) begin define lambda))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/repository-backups-directory.scm")))
    (else (include "repository-backups-directory.scm"))))
