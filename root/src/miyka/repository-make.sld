
(define-library
  (miyka repository-make)
  (export repository:make)
  (import
    (only (euphrates define-type9) define-type9))
  (import
    (only (euphrates unique-identifier)
          make-unique-identifier))
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/repository-make.scm")))
    (else (include "repository-make.scm"))))
