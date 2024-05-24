
(define-library
  (miyka guix-executable-p)
  (export guix-executable/p)
  (import
    (only (scheme base) begin define make-parameter))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/guix-executable-p.scm")))
    (else (include "guix-executable-p.scm"))))
