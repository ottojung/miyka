
(define-library
  (miyka get-fetcher)
  (export get-fetcher)
  (import (only (euphrates raisu) raisu))
  (import (only (euphrates stringf) stringf))
  (import
    (only (miyka fetcher-var-name) fetcher-var-name))
  (import (only (miyka get-root) get-root/default))
  (import
    (only (scheme base)
          begin
          define
          equal?
          if
          or
          quote))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/get-fetcher.scm")))
    (else (include "get-fetcher.scm"))))
