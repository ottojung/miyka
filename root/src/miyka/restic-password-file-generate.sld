
(define-library
  (miyka restic-password-file-generate)
  (export restic-password-file:generate)
  (import (only (euphrates stringf) stringf))
  (import
    (only (euphrates system-star-exit-code)
          system*/exit-code))
  (import
    (only (miyka get-guix-executable)
          get-guix-executable))
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/restic-password-file-generate.scm")))
    (else (include "restic-password-file-generate.scm"))))
