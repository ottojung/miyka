
(define-library
  (miyka save-repository-context)
  (export save-repository-context)
  (import
    (only (euphrates append-posix-path)
          append-posix-path))
  (import
    (only (miyka guix-describe) guix-describe))
  (import
    (only (miyka repository-state-directory)
          repository:state-directory))
  (import
    (only (miyka snapshot-repository-files)
          snapshot-repository-files))
  (import
    (only (miyka state-directory-path)
          state-directory:path))
  (import (only (scheme base) begin define values))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/save-repository-context.scm")))
    (else (include "save-repository-context.scm"))))
