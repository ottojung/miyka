
(define-library
  (miyka repository-path)
  (export repository:path)
  (import
    (only (euphrates append-posix-path)
          append-posix-path))
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import
    (only (miyka check-repo-name) check-repo-name))
  (import
    (only (miyka get-repositories-directory)
          get-repositories-directory))
  (import
    (only (scheme base) begin define lambda let))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/repository-path.scm")))
    (else (include "repository-path.scm"))))
