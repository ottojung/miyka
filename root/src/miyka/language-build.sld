
(define-library
  (miyka language-build)
  (export language:build)
  (import
    (only (euphrates properties) set-property!))
  (import
    (only (miyka current-repository-p)
          current-repository/p))
  (import
    (only (miyka do-docker-build) do-docker-build))
  (import
    (only (miyka dockerfile-repository)
          dockerfile:repository))
  (import
    (only (scheme base)
          begin
          define
          quasiquote
          unquote))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/language-build.scm")))
    (else (include "language-build.scm"))))
