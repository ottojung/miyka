
(define-library
  (miyka CLI-list)
  (export CLI:list)
  (import
    (only (euphrates directory-files)
          directory-files))
  (import
    (only (euphrates euphrates-list-sort)
          euphrates:list-sort))
  (import
    (only (euphrates file-or-directory-exists-q)
          file-or-directory-exists?))
  (import
    (only (miyka get-repositories-directory)
          get-repositories-directory))
  (import
    (only (scheme base)
          begin
          cadr
          define
          for-each
          lambda
          let
          map
          newline
          string<?
          when))
  (import (only (scheme write) display))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin (include-from-path "miyka/CLI-list.scm")))
    (else (include "CLI-list.scm"))))
