
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
    (only (euphrates get-current-directory)
          get-current-directory))
  (import (only (euphrates memconst) memconst))
  (import (only (euphrates raisu-fmt) raisu-fmt))
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
          quote))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin (include-from-path "miyka/get-root.scm")))
    (else (include "get-root.scm"))))
