
(define-library
  (miyka get-repositories-name-map)
  (export get-repositories-name-map)
  (import
    (only (miyka get-repositories-name-map-path)
          get-repositories-name-map-path))
  (import (only (scheme base) begin define))
  (import
    (only (scheme file) call-with-input-file))
  (import (only (scheme read) read))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/get-repositories-name-map.scm")))
    (else (include "get-repositories-name-map.scm"))))
