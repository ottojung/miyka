
(define-library
  (miyka id-value)
  (export id:value)
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import (only (euphrates tilda-a) ~a))
  (import (only (miyka id-path) id:path))
  (import (only (scheme base) begin define lambda))
  (import
    (only (scheme file) call-with-input-file))
  (import (only (scheme read) read))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin (include-from-path "miyka/id-value.scm")))
    (else (include "id-value.scm"))))
