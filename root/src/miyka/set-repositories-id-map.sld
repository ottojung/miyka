
(define-library
  (miyka set-repositories-id-map)
  (export set-repositories-id-map)
  (import
    (only (euphrates define-pair) define-pair))
  (import
    (only (miyka call-with-output-file-lazy)
          call-with-output-file/lazy))
  (import
    (only (miyka get-repositories-id-map-path)
          get-repositories-id-map-path))
  (import
    (only (scheme base)
          begin
          define
          for-each
          lambda
          newline))
  (import (only (scheme write) display))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/set-repositories-id-map.scm")))
    (else (include "set-repositories-id-map.scm"))))
