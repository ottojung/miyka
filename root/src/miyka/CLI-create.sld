
(define-library
  (miyka CLI-create)
  (export CLI:create)
  (import
    (only (euphrates file-or-directory-exists-q)
          file-or-directory-exists?))
  (import
    (only (euphrates make-directories)
          make-directories))
  (import (only (euphrates stringf) stringf))
  (import
    (only (miyka create-docker-file)
          create-docker-file))
  (import (only (miyka raisu-user) raisu/user))
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
