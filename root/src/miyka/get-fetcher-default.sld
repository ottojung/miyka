
(define-library
  (miyka get-fetcher-default)
  (export get-fetcher/default)
  (import (only (euphrates memconst) memconst))
  (import
    (only (euphrates system-environment)
          system-environment-get))
  (import (only (miyka fetcher-p) fetcher/p))
  (import
    (only (miyka fetcher-var-name) fetcher-var-name))
  (import (only (scheme base) begin define or))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/get-fetcher-default.scm")))
    (else (include "get-fetcher-default.scm"))))
