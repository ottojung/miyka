
(define-library
  (miyka get-repositories-id-map)
  (export get-repositories-id-map)
  (import
    (only (miyka get-repositories-id-map-path)
          get-repositories-id-map-path))
  (import (only (scheme base) begin define))
  (import
    (only (scheme file) call-with-input-file))
  (import (only (scheme read) read))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/get-repositories-id-map.scm")))
    (else (include "get-repositories-id-map.scm"))))
