
(define-library
  (miyka CLI-get-repository-home)
  (export CLI:get-repository-home)
  (import (only (miyka home-path) home:path))
  (import
    (only (miyka repository-home) repository:home))
  (import
    (only (scheme base) begin define newline))
  (import (only (scheme write) display))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/CLI-get-repository-home.scm")))
    (else (include "CLI-get-repository-home.scm"))))
