
(define-library
  (miyka dockerfile-repository)
  (export dockerfile:repository)
  (import
    (only (euphrates properties) define-property))
  (import (only (scheme base) begin))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/dockerfile-repository.scm")))
    (else (include "dockerfile-repository.scm"))))
