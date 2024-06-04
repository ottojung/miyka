
(define-library
  (miyka repositories-name-map-remove)
  (export repositories-name-map:remove)
  (import
    (only (scheme base)
          begin
          car
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
               "miyka/repositories-name-map-remove.scm")))
    (else (include "repositories-name-map-remove.scm"))))
