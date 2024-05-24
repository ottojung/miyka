
(define-library
  (miyka get-guix-executable-default)
  (export get-guix-executable/default)
  (import
    (only (euphrates define-pair) define-pair))
  (import
    (only (euphrates string-strip) string-strip))
  (import
    (only (euphrates system-environment)
          system-environment-get))
  (import (only (euphrates system-re) system-re))
  (import
    (only (miyka guix-executable-env-variable-name)
          guix-executable-env-variable-name))
  (import
    (only (scheme base) = and begin define let or))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/get-guix-executable-default.scm")))
    (else (include "get-guix-executable-default.scm"))))
