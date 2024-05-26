
(define-library
  (miyka CLI-create)
  (export CLI:create)
  (import (only (euphrates fprintf) fprintf))
  (import
    (only (euphrates make-directories)
          make-directories))
  (import
    (only (euphrates path-get-dirname)
          path-get-dirname))
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
    (only (miyka enter-script-path)
          enter-script:path))
  (import
    (only (miyka enter-script-template)
          enter-script:template))
  (import
    (only (miyka get-guix-executable)
          get-guix-executable))
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
    (only (miyka repository-enter-script)
          repository:enter-script))
  (import
    (only (miyka repository-init-script)
          repository:init-script))
  (import
    (only (miyka repository-restic-password-file)
          repository:restic-password-file))
  (import
    (only (miyka restic-password-file-path)
          restic-password-file:path))
  (import
    (only (miyka restic-password-file-generate)
          restic-password-file:generate))
  (import
    (only (scheme base)
          begin
          define
          lambda
          let
          values))
  (import
    (only (scheme file) call-with-output-file))
  (import (only (scheme write) display))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/CLI-create.scm")))
    (else (include "CLI-create.scm"))))
