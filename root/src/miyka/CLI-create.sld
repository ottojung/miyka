
(define-library
  (miyka CLI-create)
  (export CLI:create)
  (import
    (only (euphrates make-directories)
          make-directories))
  (import (only (euphrates stringf) stringf))
  (import
    (only (miyka create-docker-file)
          create-docker-file))
  (import
    (only (miyka do-docker-build) do-docker-build))
  (import (only (miyka raisu-user) raisu/user))
  (import
    (only (miyka repository-exists-in-docker-huh)
          repository:exists-in-docker?))
  (import
    (only (miyka repository-exists-on-disk-huh)
          repository:exists-on-disk?))
  (import
    (only (miyka repository-path) repository:path))
  (import
    (only (scheme base)
          begin
          define
          quote
          values
          when))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/CLI-create.scm")))
    (else (include "CLI-create.scm"))))
