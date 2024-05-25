
(define-library
  (miyka language-git)
  (export language:git)
  (import (only (euphrates stack) stack-push!))
  (import
    (only (miyka interpretation-p) interpretation/p))
  (import
    (only (miyka interpretation)
          interpretation:git-stack))
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/language-git.scm")))
    (else (include "language-git.scm"))))
