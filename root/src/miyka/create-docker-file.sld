
(define-library
  (miyka create-docker-file)
  (export create-docker-file)
  (import (only (euphrates fprintf) fprintf))
  (import
    (only (miyka docker-file-template)
          docker-file-template))
  (import
    (only (miyka repository-dockerfile)
          repository:dockerfile))
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
