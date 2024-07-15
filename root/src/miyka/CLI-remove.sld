
(define-library
  (miyka CLI-remove)
  (export CLI:remove)
  (import
    (only (euphrates system-star-exit-code)
          system*/exit-code))
  (import
    (only (miyka get-guix-executable)
          get-guix-executable))
  (import
    (only (miyka get-repositories-id-map)
          get-repositories-id-map))
  (import (only (miyka id-value) id:value))
  (import
    (only (miyka repositories-id-map-remove)
          repositories-id-map:remove))
  (import
    (only (miyka repository-id) repository:id))
  (import
    (only (miyka repository-path) repository:path))
  (import
    (only (miyka set-repositories-id-map)
          set-repositories-id-map))
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/CLI-remove.scm")))
    (else (include "CLI-remove.scm"))))
