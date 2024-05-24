
(define-library
  (miyka CLI-remove)
  (export CLI:remove)
  (import (only (euphrates raisu-fmt) raisu-fmt))
  (import
    (only (euphrates system-star-exit-code)
          system*/exit-code))
  (import
    (only (miyka get-guix-executable)
          get-guix-executable))
  (import
    (only (miyka repository-exists-on-disk-huh)
          repository:exists-on-disk?))
  (import
    (only (miyka repository-name) repository:name))
  (import
    (only (miyka repository-path) repository:path))
  (import
    (only (scheme base) begin define quote unless))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/CLI-remove.scm")))
    (else (include "CLI-remove.scm"))))
