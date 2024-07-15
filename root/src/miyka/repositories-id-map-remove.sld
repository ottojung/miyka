
(define-library
  (miyka repositories-id-map-remove)
  (export repositories-id-map:remove)
  (import
    (only (scheme base)
          begin
          cdr
          define
          equal?
          lambda
          not))
  (cond-expand
    (guile (import (only (srfi srfi-1) filter)))
    (else (import (only (srfi 1) filter))))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/repositories-id-map-remove.scm")))
    (else (include "repositories-id-map-remove.scm"))))
