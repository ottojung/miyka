
(define-library
  (miyka get-repositories-id-map-path)
  (export get-repositories-id-map-path)
  (import
    (only (euphrates append-posix-path)
          append-posix-path))
  (import
    (only (euphrates file-or-directory-exists-q)
          file-or-directory-exists?))
  (import
    (only (euphrates make-directories)
          make-directories))
  (import (only (euphrates memconst) memconst))
  (import
    (only (miyka call-with-output-file-lazy)
          call-with-output-file/lazy))
  (import (only (miyka get-root) get-root))
  (import
    (only (scheme base)
          begin
          define
          lambda
          let
          newline
          unless))
  (import (only (scheme write) display))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/get-repositories-id-map-path.scm")))
    (else (include "get-repositories-id-map-path.scm"))))
