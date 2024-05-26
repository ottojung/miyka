
(define-library
  (miyka restic-password-file-generate)
  (export restic-password-file:generate)
  (import (only (scheme base) begin define lambda))
  (import
    (only (scheme file) call-with-output-file))
  (import (only (scheme write) display))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/restic-password-file-generate.scm")))
    (else (include "restic-password-file-generate.scm"))))
