
(define-library
  (miyka id-map-add-repository-awkscript-path)
  (export id-map-add-repository-awkscript:path)
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/id-map-add-repository-awkscript-path.scm")))
    (else (include
            "id-map-add-repository-awkscript-path.scm"))))
