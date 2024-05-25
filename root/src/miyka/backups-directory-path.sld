
(define-library
  (miyka backups-directory-path)
  (export backups-directory:path)
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import (only (scheme base) begin lambda))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/backups-directory-path.scm")))
    (else (include "backups-directory-path.scm"))))
