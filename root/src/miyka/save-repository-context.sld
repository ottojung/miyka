
(define-library
  (miyka save-repository-context)
  (export save-repository-context)
  (import
    (only (euphrates append-posix-path)
          append-posix-path))
  (import
    (only (euphrates date-get-current-string)
          date-get-current-string))
  (import (only (euphrates file-copy) file-copy))
  (import
    (only (euphrates make-directories)
          make-directories))
  (import
    (only (euphrates path-get-basename)
          path-get-basename))
  (import
    (only (miyka guix-describe) guix-describe))
  (import
    (only (miyka log-directory-path)
          log-directory:path))
  (import
    (only (miyka manifest-path) manifest:path))
  (import
    (only (miyka repository-log-directory)
          repository:log-directory))
  (import
    (only (miyka repository-manifest)
          repository:manifest))
  (import
    (only (miyka repository-path) repository:path))
  (import (only (scheme base) begin define values))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/save-repository-context.scm")))
    (else (include "save-repository-context.scm"))))
