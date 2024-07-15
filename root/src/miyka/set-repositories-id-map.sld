
(define-library
  (miyka set-repositories-id-map)
  (export set-repositories-id-map)
  (import
    (only (miyka call-with-output-file-lazy)
          call-with-output-file/lazy))
  (import
    (only (miyka get-repositories-id-map-path)
          get-repositories-id-map-path))
  (import (only (scheme base) begin define lambda))
  (import (only (scheme write) write))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/set-repositories-id-map.scm")))
    (else (include "set-repositories-id-map.scm"))))
