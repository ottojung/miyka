
(define-library
  (miyka interpretation)
  (export
    make-interpretation
    interpretation?
    interpretation:installstack
    interpretation:commands
    interpretation:home-moved?
    interpretation:cleanup
    interpretation:snapshot?
    interpretation:pure?
    interpretation:host-stack
    interpretation:git-stack)
  (import (only (euphrates box) make-box))
  (import
    (only (euphrates define-type9) define-type9))
  (import (only (euphrates stack) stack-make))
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/interpretation.scm")))
    (else (include "interpretation.scm"))))
