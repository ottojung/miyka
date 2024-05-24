
(define-library
  (miyka guix-executable-env-variable-name)
  (export guix-executable-env-variable-name)
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/guix-executable-env-variable-name.scm")))
    (else (include "guix-executable-env-variable-name.scm"))))
