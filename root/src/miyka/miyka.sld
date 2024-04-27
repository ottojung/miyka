
(define-library
  (miyka miyka)
  (import
    (only (euphrates define-cli)
          define-cli:show-help
          with-cli))
  (import
    (only (euphrates with-ignore-errors)
          with-ignore-errors!))
  (import
    (only (scheme base) / begin cond define newline))
  (import (only (scheme write) display))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/miyka.scm")))
    (else (include "miyka.scm"))))
