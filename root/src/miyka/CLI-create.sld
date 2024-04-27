
(define-library
  (miyka CLI-create)
  (export CLI:create)
  (import
    (only (euphrates append-posix-path)
          append-posix-path))
  (import
    (only (euphrates file-or-directory-exists-q)
          file-or-directory-exists?))
  (import
    (only (euphrates make-directories)
          make-directories))
  (import (only (euphrates raisu) raisu))
  (import (only (euphrates stringf) stringf))
  (import
    (only (miyka check-repo-name) check-repo-name))
  (import
    (only (miyka create-docker-file)
          create-docker-file))
  (import
    (only (miyka get-repositories-directory)
          get-repositories-directory))
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
