
(define-library
  (miyka id-map-add-repository-awkscript-template)
  (export id-map-add-repository-awkscript:template)
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/id-map-add-repository-awkscript-template.scm")))
    (else (include
            "id-map-add-repository-awkscript-template.scm"))))
