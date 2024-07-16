
(define-library
  (miyka CLI-import-directory)
  (export CLI:import-directory)
  (import
    (only (euphrates file-or-directory-exists-q)
          file-or-directory-exists?))
  (import
    (only (euphrates properties)
          set-property!
          with-properties))
  (import (only (euphrates raisu-fmt) raisu-fmt))
  (import (only (euphrates stringf) stringf))
  (import
    (only (euphrates system-star-exit-code)
          system*/exit-code))
  (import (only (euphrates tilda-a) ~a))
  (import
    (only (miyka check-if-repository-already-exists)
          check-if-repository-already-exists))
  (import
    (only (miyka get-guix-executable)
          get-guix-executable))
  (import (only (miyka id-path) id:path))
  (import
    (only (miyka register-repository-name)
          register-repository-name))
  (import
    (only (miyka repository-id) repository:id))
  (import
    (only (miyka repository-make) repository:make))
  (import
    (only (miyka repository-name) repository:name))
  (import
    (only (miyka repository-path) repository:path))
  (import
    (only (scheme base)
          =
          begin
          define
          let
          quote
          unless
          values))
  (import
    (only (scheme file) call-with-input-file))
  (import (only (scheme read) read))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/CLI-import-directory.scm")))
    (else (include "CLI-import-directory.scm"))))
