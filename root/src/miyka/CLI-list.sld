
(define-library
  (miyka CLI-list)
  (export CLI:list)
  (import
    (only (euphrates define-tuple) define-tuple))
  (import
    (only (euphrates directory-files)
          directory-files))
  (import
    (only (euphrates file-or-directory-exists-q)
          file-or-directory-exists?))
  (import
    (only (miyka get-repositories-directory)
          get-repositories-directory))
  (import
    (only (scheme base)
          begin
          define
          for-each
          lambda
          newline
          when))
  (import (only (scheme write) display))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin (include-from-path "miyka/CLI-list.scm")))
    (else (include "CLI-list.scm"))))
