
(define-library
  (miyka CLI-create)
  (export CLI:create)
  (import
    (only (euphrates make-directories)
          make-directories))
  (import
    (only (euphrates path-get-dirname)
          path-get-dirname))
  (import
    (only (miyka call-with-output-file-lazy)
          call-with-output-file/lazy))
  (import
    (only (miyka check-if-repository-already-exists)
          check-if-repository-already-exists))
  (import
    (only (miyka configuration-path)
          configuration:path))
  (import
    (only (miyka configuration-template)
          configuration:template))
  (import
    (only (miyka init-script-path) init-script:path))
  (import
    (only (miyka init-script-template)
          init-script:template))
  (import
    (only (miyka initialize-repository)
          initialize-repository))
  (import
    (only (miyka repository-configuration)
          repository:configuration))
  (import
    (only (miyka repository-init-script)
          repository:init-script))
  (import
    (only (scheme base)
          begin
          define
          lambda
          let
          values))
  (import (only (scheme write) display))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/CLI-create.scm")))
    (else (include "CLI-create.scm"))))
