
(define-library
  (miyka repository-configuration-directory)
  (export repository:configuration-directory)
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import
    (only (miyka repository-path) repository:path))
  (import
    (only (miyka repository-work-directory)
          repository:work-directory))
  (import
    (only (miyka work-directory-path)
          work-directory:path))
  (import (only (scheme base) begin define lambda))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/repository-configuration-directory.scm")))
    (else (include
            "repository-configuration-directory.scm"))))
