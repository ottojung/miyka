
(define-library
  (miyka language-install)
  (export language:install)
  (import (only (euphrates stack) stack-push!))
  (import
    (only (miyka install-list-p) install-list/p))
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/language-install.scm")))
    (else (include "language-install.scm"))))
