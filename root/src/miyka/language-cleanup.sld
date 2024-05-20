
(define-library
  (miyka language-cleanup)
  (export language:cleanup)
  (import (only (euphrates box) box-set!))
  (import
    (only (miyka interpretation-p) interpretation/p))
  (import
    (only (miyka interpretation)
          interpretation:cleanup))
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/language-cleanup.scm")))
    (else (include "language-cleanup.scm"))))
