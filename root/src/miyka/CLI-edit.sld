
(define-library
  (miyka CLI-edit)
  (export CLI:edit)
  (import (only (euphrates raisu-fmt) raisu-fmt))
  (import
    (only (euphrates run-syncproc) run-syncproc))
  (import
    (only (miyka get-current-editor)
          get-current-editor))
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
          =
          begin
          define
          let
          quote
          unless))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin (include-from-path "miyka/CLI-edit.scm")))
    (else (include "CLI-edit.scm"))))
