
(define-library
  (miyka language-snapshot)
  (export language:snapshot)
  (import (only (euphrates box) box-set!))
  (import
    (only (miyka interpretation-p) interpretation/p))
  (import
    (only (miyka interpretation)
          interpretation:snapshot?))
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/language-snapshot.scm")))
    (else (include "language-snapshot.scm"))))
