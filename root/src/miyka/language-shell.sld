
(define-library
  (miyka language-shell)
  (export language:shell)
  (import (only (euphrates stack) stack-push!))
  (import
    (only (miyka command-shell) command:shell:make))
  (import
    (only (miyka interpretation-p) interpretation/p))
  (import
    (only (miyka interpretation)
          interpretation:commands))
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/language-shell.scm")))
    (else (include "language-shell.scm"))))
