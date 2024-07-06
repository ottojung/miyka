
(define-library
  (miyka language-environment)
  (export language:environment)
  (import (only (euphrates box) box-set!))
  (import
    (only (miyka interpretation-p) interpretation/p))
  (import
    (only (miyka interpretation)
          interpretation:environment))
  (import (only (scheme base) begin define))
  (import (only (scheme eval) environment))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/language-environment.scm")))
    (else (include "language-environment.scm"))))
