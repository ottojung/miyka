
(define-library
  (miyka register-repository-name)
  (export register-repository-name)
  (import
    (only (euphrates assoc-set-value)
          assoc-set-value))
  (import
    (only (miyka get-repositories-name-map)
          get-repositories-name-map))
  (import
    (only (miyka repository-name) repository:name))
  (import
    (only (miyka set-repositories-name-map)
          set-repositories-name-map))
  (import (only (scheme base) begin define values))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/register-repository-name.scm")))
    (else (include "register-repository-name.scm"))))
