
(define-library
  (miyka CLI-get-name)
  (export CLI:get-name)
  (import
    (only (miyka repository-name) repository:name))
  (import
    (only (scheme base) begin define newline))
  (import (only (scheme write) display))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/CLI-get-name.scm")))
    (else (include "CLI-get-name.scm"))))
