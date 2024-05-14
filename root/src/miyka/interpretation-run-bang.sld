
(define-library
  (miyka interpretation-run-bang)
  (export interpretation:run!)
  (import
    (only (euphrates system-star-exit-code)
          system*/exit-code))
  (import
    (only (miyka interpretation-installist)
          interpretation:installist))
  (import
    (only (miyka manifest-path) manifest:path))
  (import
    (only (miyka repository-manifest)
          repository:manifest))
  (import
    (only (miyka repository-path) repository:path))
  (import
    (only (miyka repository-start-script)
          repository:start-script))
  (import
    (only (miyka start-script-path)
          start-script:path))
  (import
    (only (scheme base)
          begin
          define
          lambda
          quasiquote
          quote
          string-append
          unquote))
  (import
    (only (scheme file) call-with-output-file))
  (import (only (scheme write) write))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/interpretation-run-bang.scm")))
    (else (include "interpretation-run-bang.scm"))))
