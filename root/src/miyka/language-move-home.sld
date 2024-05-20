
(define-library
  (miyka language-move-home)
  (export language:move-home)
  (import (only (euphrates box) box-set!))
  (import
    (only (miyka interpretation-p) interpretation/p))
  (import
    (only (miyka interpretation)
          interpretation:home-moved?))
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/language-move-home.scm")))
    (else (include "language-move-home.scm"))))
