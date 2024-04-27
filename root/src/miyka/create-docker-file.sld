
(define-library
  (miyka create-docker-file)
  (export create-docker-file)
  (import
    (only (euphrates append-posix-path)
          append-posix-path))
  (import (only (euphrates fprintf) fprintf))
  (import
    (only (euphrates make-directories)
          make-directories))
  (import
    (only (miyka docker-file-name) docker-file-name))
  (import
    (only (miyka docker-file-template)
          docker-file-template))
  (import
    (only (scheme base)
          begin
          current-output-port
          define
          lambda
          parameterize
          values))
  (import
    (only (scheme file) call-with-output-file))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/create-docker-file.scm")))
    (else (include "create-docker-file.scm"))))
