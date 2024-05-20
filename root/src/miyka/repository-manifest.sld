
(define-library
  (miyka repository-manifest)
  (export repository:manifest)
  (import
    (only (euphrates append-posix-path)
          append-posix-path))
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import
    (only (miyka repository-work-directory)
          repository:work-directory))
  (import
    (only (miyka work-directory-path)
          work-directory:path))
  (import (only (scheme base) begin define lambda))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/repository-manifest.scm")))
    (else (include "repository-manifest.scm"))))
