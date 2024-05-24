
(define-library
  (miyka CLI-import)
  (export CLI:import)
  (import
    (only (euphrates path-get-basename)
          path-get-basename))
  (import (only (euphrates raisu-fmt) raisu-fmt))
  (import
    (only (euphrates system-star-exit-code)
          system*/exit-code))
  (import
    (only (miyka check-if-repository-already-exists)
          check-if-repository-already-exists))
  (import
    (only (miyka get-guix-executable)
          get-guix-executable))
  (import
    (only (miyka repository-path) repository:path))
  (import
    (only (scheme base)
          =
          begin
          define
          or
          quote
          unless
          values))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/CLI-import.scm")))
    (else (include "CLI-import.scm"))))
