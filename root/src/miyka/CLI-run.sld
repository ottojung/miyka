
(define-library
  (miyka CLI-run)
  (export CLI:run)
  (import (only (euphrates raisu-fmt) raisu-fmt))
  (import
    (only (miyka configuration-path)
          configuration:path))
  (import
    (only (miyka interpretation-run-bang)
          interpretation:run!))
  (import
    (only (miyka load-and-interpret)
          load-and-interpret))
  (import
    (only (miyka repository-configuration)
          repository:configuration))
  (import
    (only (miyka repository-exists-on-disk-huh)
          repository:exists-on-disk?))
  (import
    (only (miyka repository-name) repository:name))
  (import
    (only (scheme base)
          begin
          define
          let
          quote
          unless))
  (import (only (scheme process-context) exit))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin (include-from-path "miyka/CLI-run.scm")))
    (else (include "CLI-run.scm"))))
