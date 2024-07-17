
(define-library
  (miyka fetcher-var-name)
  (export fetcher-var-name)
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/fetcher-var-name.scm")))
    (else (include "fetcher-var-name.scm"))))
