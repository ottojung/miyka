
(define-library
  (miyka command)
  (export command:make command? command:object)
  (import
    (only (euphrates define-type9) define-type9))
  (import (only (scheme base) begin))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin (include-from-path "miyka/command.scm")))
    (else (include "command.scm"))))
