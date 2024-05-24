
(define-library
  (miyka restic-password-file-path)
  (export restic-password-file:path)
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import (only (scheme base) begin lambda))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/restic-password-file-path.scm")))
    (else (include "restic-password-file-path.scm"))))
