
(define-library
  (miyka dockerfile-path)
  (export dockerfile:path)
  (import
    (only (euphrates append-posix-path)
          append-posix-path))
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import
    (only (miyka dockerfile-repository)
          dockerfile:repository))
  (import
    (only (miyka repository-path) repository:path))
  (import (only (scheme base) begin define lambda))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/dockerfile-path.scm")))
    (else (include "dockerfile-path.scm"))))
