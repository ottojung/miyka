
(define-library
  (miyka do-docker-build)
  (export do-docker-build)
  (import
    (only (euphrates make-directories)
          make-directories))
  (import
    (only (euphrates run-syncproc) run-syncproc))
  (import
    (only (miyka repository-build-context-dir)
          repository:build-context-dir))
  (import
    (only (miyka repository-dockerfile)
          repository:dockerfile))
  (import
    (only (miyka repository-image-tag)
          repository:image:tag))
  (import (only (scheme base) begin define values))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/do-docker-build.scm")))
    (else (include "do-docker-build.scm"))))
