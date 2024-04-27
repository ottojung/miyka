
(define-library
  (miyka get-root)
  (export get-root get-root/default)
  (import
    (only (euphrates absolute-posix-path-q)
          absolute-posix-path?))
  (import
    (only (euphrates append-posix-path)
          append-posix-path))
  (import
    (only (euphrates file-or-directory-exists-q)
          file-or-directory-exists?))
  (import
    (only (euphrates get-current-directory)
          get-current-directory))
  (import
    (only (euphrates make-directories)
          make-directories))
  (import (only (euphrates memconst) memconst))
  (import (only (euphrates raisu) raisu))
  (import (only (euphrates stringf) stringf))
  (import
    (only (euphrates system-environment)
          system-environment-get))
  (import (only (miyka root-p) root/p))
  (import
    (only (scheme base)
          _
          and
          begin
          define
          if
          lambda
          let
          or
          quote
          set!
          unless
          when))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin (include-from-path "miyka/get-root.scm")))
    (else (include "get-root.scm"))))
