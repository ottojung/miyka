
(define-library
  (miyka language-start)
  (export language:start)
  (import
    (only (euphrates append-posix-path)
          append-posix-path))
  (import (only (euphrates stack) stack->list))
  (import
    (only (euphrates system-star-exit-code)
          system*/exit-code))
  (import
    (only (miyka current-repository-p)
          current-repository/p))
  (import
    (only (miyka install-list-p) install-list/p))
  (import
    (only (miyka manifest-path) manifest:path))
  (import
    (only (miyka repository-manifest)
          repository:manifest))
  (import
    (only (miyka repository-path) repository:path))
  (import
    (only (scheme base)
          begin
          define
          lambda
          let
          quasiquote
          quote
          reverse
          string-append
          unquote
          values))
  (import
    (only (scheme file) call-with-output-file))
  (import (only (scheme write) write))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/language-start.scm")))
    (else (include "language-start.scm"))))
