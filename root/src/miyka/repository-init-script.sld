
(define-library
  (miyka repository-init-script)
  (export repository:init-script)
  (import
    (only (euphrates append-posix-path)
          append-posix-path))
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import (only (miyka home-path) home:path))
  (import
    (only (miyka repository-home) repository:home))
  (import
    (only (miyka repository-path) repository:path))
  (import (only (scheme base) begin define lambda))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/repository-init-script.scm")))
    (else (include "repository-init-script.scm"))))
