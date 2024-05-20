
(define-library
  (miyka command-shell)
  (export
    command:shell:make
    command:shell?
    command:shell:path)
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
             (include-from-path "miyka/command-shell.scm")))
    (else (include "command-shell.scm"))))
