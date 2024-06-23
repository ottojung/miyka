
(define-library
  (miyka CLI-copy)
  (export CLI:copy)
  (import
    (only (euphrates make-directories)
          make-directories))
  (import
    (only (euphrates path-get-dirname)
          path-get-dirname))
  (import
    (only (euphrates system-star-exit-code)
          system*/exit-code))
  (import
    (only (miyka check-if-repository-already-exists)
          check-if-repository-already-exists))
  (import
    (only (miyka configuration-path)
          configuration:path))
  (import
    (only (miyka get-guix-executable)
          get-guix-executable))
  (import
    (only (miyka initialize-repository)
          initialize-repository))
  (import
    (only (miyka repository-configuration)
          repository:configuration))
  (import
    (only (scheme base) begin define let values))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin (include-from-path "miyka/CLI-copy.scm")))
    (else (include "CLI-copy.scm"))))
