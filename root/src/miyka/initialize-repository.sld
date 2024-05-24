
(define-library
  (miyka initialize-repository)
  (export initialize-repository)
  (import
    (only (euphrates append-posix-path)
          append-posix-path))
  (import
    (only (euphrates make-directories)
          make-directories))
  (import (only (euphrates raisu-fmt) raisu-fmt))
  (import
    (only (euphrates system-star-exit-code)
          system*/exit-code))
  (import (only (miyka bin-path) bin:path))
  (import
    (only (miyka get-guix-executable)
          get-guix-executable))
  (import (only (miyka home-path) home:path))
  (import
    (only (miyka log-directory-path)
          log-directory:path))
  (import
    (only (miyka repository-bin) repository:bin))
  (import
    (only (miyka repository-home) repository:home))
  (import
    (only (miyka repository-log-directory)
          repository:log-directory))
  (import
    (only (miyka repository-path) repository:path))
  (import
    (only (miyka repository-restic-password-file)
          repository:restic-password-file))
  (import
    (only (miyka repository-state-directory)
          repository:state-directory))
  (import
    (only (miyka restic-password-file-path)
          restic-password-file:path))
  (import
    (only (miyka state-directory-path)
          state-directory:path))
  (import
    (only (scheme base)
          =
          begin
          define
          let
          quote
          unless
          values))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/initialize-repository.scm")))
    (else (include "initialize-repository.scm"))))
