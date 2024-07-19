
(define-library
  (miyka repository-id-map-add-repository-awkscript)
  (export
    repository:id-map-add-repository-awkscript)
  (import
    (only (euphrates append-posix-path)
          append-posix-path))
  (import
    (only (euphrates properties)
          define-property
          define-provider))
  (import
    (only (miyka repository-state-directory)
          repository:state-directory))
  (import
    (only (miyka state-directory-path)
          state-directory:path))
  (import (only (scheme base) begin define lambda))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/repository-id-map-add-repository-awkscript.scm")))
    (else (include
            "repository-id-map-add-repository-awkscript.scm"))))
