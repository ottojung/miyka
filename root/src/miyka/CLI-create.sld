
(define-library
  (miyka CLI-create)
  (export CLI:create)
  (import
    (only (euphrates make-directories)
          make-directories))
  (import
    (only (euphrates path-get-dirname)
          path-get-dirname))
  (import (only (euphrates raisu-fmt) raisu-fmt))
  (import
    (only (euphrates system-star-exit-code)
          system*/exit-code))
  (import
    (only (miyka check-if-repository-already-exists)
          check-if-repository-already-exists))
  (import
    (only (miyka configuration-path)
          configuration:path))
  (import
    (only (miyka configuration-template)
          configuration:template))
  (import (only (miyka home-path) home:path))
  (import
    (only (miyka init-script-path) init-script:path))
  (import
    (only (miyka init-script-template)
          init-script:template))
  (import
    (only (miyka log-directory-path)
          log-directory:path))
  (import
    (only (miyka repository-configuration)
          repository:configuration))
  (import
    (only (miyka repository-home) repository:home))
  (import
    (only (miyka repository-init-script)
          repository:init-script))
  (import
    (only (miyka repository-log-directory)
          repository:log-directory))
  (import
    (only (miyka repository-path) repository:path))
  (import
    (only (miyka repository-state-directory)
          repository:state-directory))
  (import
    (only (miyka state-directory-path)
          state-directory:path))
  (import
    (only (scheme base)
          =
          begin
          define
          lambda
          let
          quote
          unless
          values))
  (import
    (only (scheme file) call-with-output-file))
  (import (only (scheme write) display))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/CLI-create.scm")))
    (else (include "CLI-create.scm"))))
