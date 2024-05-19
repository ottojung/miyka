
(define-library
  (miyka snapshot-repository-files)
  (export snapshot-repository-files)
  (import (only (euphrates raisu-fmt) raisu-fmt))
  (import
    (only (euphrates system-star-exit-code)
          system*/exit-code))
  (import
    (only (miyka log-directory-path)
          log-directory:path))
  (import
    (only (miyka repository-log-directory)
          repository:log-directory))
  (import
    (only (miyka repository-work-directory)
          repository:work-directory))
  (import
    (only (miyka work-directory-path)
          work-directory:path))
  (import
    (only (scheme base) = begin define quote unless))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/snapshot-repository-files.scm")))
    (else (include "snapshot-repository-files.scm"))))
