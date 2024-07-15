
(define-library
  (miyka language-install-sh)
  (export language:install-sh)
  (import (only (euphrates box) box-set!))
  (import
    (only (miyka interpretation-p) interpretation/p))
  (import
    (only (miyka interpretation)
          interpretation:install-sh?))
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/language-install-sh.scm")))
    (else (include "language-install-sh.scm"))))
