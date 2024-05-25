
(define-library
  (miyka language-host)
  (export language:host)
  (import (only (euphrates stack) stack-push!))
  (import
    (only (miyka interpretation-p) interpretation/p))
  (import
    (only (miyka interpretation)
          interpretation:host-stack))
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/language-host.scm")))
    (else (include "language-host.scm"))))
