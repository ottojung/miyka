
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
    (only (miyka get-guix-executable)
          get-guix-executable))
  (import
    (only (miyka initialize-repository)
          initialize-repository))
  (import
    (only (miyka repository-state-directory)
          repository:state-directory))
  (import
    (only (miyka state-directory-path)
          state-directory:path))
  (import
    (only (scheme base) begin define let values))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin (include-from-path "miyka/CLI-copy.scm")))
    (else (include "CLI-copy.scm"))))
