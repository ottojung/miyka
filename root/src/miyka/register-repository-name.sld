
(define-library
  (miyka register-repository-name)
  (export register-repository-name)
  (import
    (only (euphrates assoc-set-value)
          assoc-set-value))
  (import
    (only (euphrates properties) set-property!))
  (import
    (only (miyka get-repositories-id-map)
          get-repositories-id-map))
  (import (only (miyka id-value) id:value))
  (import
    (only (miyka repository-id) repository:id))
  (import
    (only (miyka set-repositories-id-map)
          set-repositories-id-map))
  (import (only (scheme base) begin define values))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/register-repository-name.scm")))
    (else (include "register-repository-name.scm"))))
