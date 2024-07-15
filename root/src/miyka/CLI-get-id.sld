
(define-library
  (miyka CLI-get-id)
  (export CLI:get-id)
  (import (only (miyka id-value) id:value))
  (import
    (only (miyka repository-id) repository:id))
  (import
    (only (scheme base) begin define newline))
  (import (only (scheme write) display))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/CLI-get-id.scm")))
    (else (include "CLI-get-id.scm"))))
