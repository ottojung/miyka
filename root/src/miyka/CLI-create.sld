
(define-library
  (miyka CLI-create)
  (export CLI:create)
  (import
    (only (euphrates make-directories)
          make-directories))
  (import
    (only (miyka check-if-repository-already-exists)
          check-if-repository-already-exists))
  (import
    (only (miyka create-docker-file)
          create-docker-file))
  (import
    (only (miyka do-docker-build) do-docker-build))
  (import
    (only (miyka repository-path) repository:path))
  (import (only (scheme base) begin define values))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/CLI-create.scm")))
    (else (include "CLI-create.scm"))))
