
(define-library
  (miyka get-repositories-directory)
  (export get-repositories-directory)
  (import
    (only (euphrates append-posix-path)
          append-posix-path))
  (import (only (euphrates memconst) memconst))
  (import (only (miyka get-root) get-root))
  (import (only (scheme base) begin define let))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/get-repositories-directory.scm")))
    (else (include "get-repositories-directory.scm"))))
