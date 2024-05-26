
(define-library
  (miyka repository-ps-script)
  (export repository:ps-script)
  (import
    (only (euphrates append-posix-path)
          append-posix-path))
  (import
    (only (miyka repository-state-directory)
          repository:state-directory))
  (import
    (only (miyka state-directory-path)
          state-directory:path))
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/repository-ps-script.scm")))
    (else (include "repository-ps-script.scm"))))
