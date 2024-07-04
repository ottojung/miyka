
(define-library
  (miyka CLI-get-root-path)
  (export CLI:get-root-path)
  (import
    (only (miyka repository-path) repository:path))
  (import
    (only (scheme base) begin define newline))
  (import (only (scheme write) display))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/CLI-get-root-path.scm")))
    (else (include "CLI-get-root-path.scm"))))
