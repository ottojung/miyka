
(define-library
  (miyka command-detach)
  (export command:detach:make command:detach?)
  (import
    (only (euphrates define-type9) define-type9))
  (import
    (only (miyka command)
          command:make
          command:object
          command?))
  (import (only (scheme base) and begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/command-detach.scm")))
    (else (include "command-detach.scm"))))
