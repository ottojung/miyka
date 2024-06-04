
(define-library
  (miyka get-repositories-name-map-path)
  (export get-repositories-name-map-path)
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
  (import (only (miyka get-root) get-root))
  (import
    (only (scheme base)
          begin
          define
          lambda
          let
          quote
          unless))
  (import
    (only (scheme file) call-with-output-file))
  (import (only (scheme write) write))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/get-repositories-name-map-path.scm")))
    (else (include "get-repositories-name-map-path.scm"))))
