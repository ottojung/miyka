
(define-library
  (miyka CLI-get-config-path)
  (export CLI:get-config-path)
  (import
    (only (miyka configuration-path)
          configuration:path))
  (import
    (only (miyka repository-configuration)
          repository:configuration))
  (import
    (only (scheme base) begin define newline))
  (import (only (scheme write) display))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/CLI-get-config-path.scm")))
    (else (include "CLI-get-config-path.scm"))))
