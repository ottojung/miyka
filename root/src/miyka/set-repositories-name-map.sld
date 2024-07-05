
(define-library
  (miyka set-repositories-name-map)
  (export set-repositories-name-map)
  (import
    (only (miyka call-with-output-file-lazy)
          call-with-output-file/lazy))
  (import
    (only (miyka get-repositories-name-map-path)
          get-repositories-name-map-path))
  (import (only (scheme base) begin define lambda))
  (import (only (scheme write) write))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/set-repositories-name-map.scm")))
    (else (include "set-repositories-name-map.scm"))))
