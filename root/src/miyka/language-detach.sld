
(define-library
  (miyka language-detach)
  (export language:detach)
  (import (only (euphrates stack) stack-push!))
  (import
    (only (miyka command-detach) command:detach:make))
  (import
    (only (miyka interpretation-p) interpretation/p))
  (import
    (only (miyka interpretation)
          interpretation:commands))
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/language-detach.scm")))
    (else (include "language-detach.scm"))))
