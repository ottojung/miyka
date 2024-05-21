
(define-library
  (miyka cleanup-wrapper-path)
  (export cleanup-wrapper:path)
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import (only (scheme base) begin lambda))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/cleanup-wrapper-path.scm")))
    (else (include "cleanup-wrapper-path.scm"))))
