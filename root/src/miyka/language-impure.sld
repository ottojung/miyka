
(define-library
  (miyka language-impure)
  (export language:impure)
  (import (only (euphrates box) box-set!))
  (import
    (only (miyka interpretation-p) interpretation/p))
  (import
    (only (miyka interpretation)
          interpretation:pure?))
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/language-impure.scm")))
    (else (include "language-impure.scm"))))
