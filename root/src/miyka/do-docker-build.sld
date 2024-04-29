
(define-library
  (miyka do-docker-build)
  (export do-docker-build)
  (import
    (only (euphrates make-directories)
          make-directories))
  (import (only (euphrates raisu-fmt) raisu-fmt))
  (import
    (only (euphrates system-star-exit-code)
          system*/exit-code))
  (import
    (only (miyka dockerfile-image) dockerfile:image))
  (import
    (only (miyka dockerfile-path) dockerfile:path))
  (import
    (only (miyka dockerfile-repository)
          dockerfile:repository))
  (import (only (miyka image-tag) image:tag))
  (import
    (only (miyka repository-build-context-dir)
          repository:build-context-dir))
  (import
    (only (scheme base)
          =
          begin
          define
          quote
          unless
          values))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/do-docker-build.scm")))
    (else (include "do-docker-build.scm"))))
