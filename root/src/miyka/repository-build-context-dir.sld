
(define-library
  (miyka repository-build-context-dir)
  (export repository:build-context-dir)
  (import
    (only (euphrates append-posix-path)
          append-posix-path))
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
               "miyka/repository-build-context-dir.scm")))
    (else (include "repository-build-context-dir.scm"))))
