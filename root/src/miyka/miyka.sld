
(define-library
  (miyka miyka)
  (export main)
  (import
    (only (euphrates define-cli)
          define-cli:show-help
          with-cli))
  (import
    (only (euphrates properties) with-properties))
  (import
    (only (euphrates with-ignore-errors)
          with-ignore-errors!))
  (import
    (only (euphrates with-user-errors)
          with-user-errors))
  (import (only (miyka CLI-copy) CLI:copy))
  (import (only (miyka CLI-create) CLI:create))
  (import (only (miyka CLI-edit) CLI:edit))
  (import (only (miyka CLI-list) CLI:list))
  (import (only (miyka CLI-remove) CLI:remove))
  (import (only (miyka CLI-run) CLI:run))
  (import (only (miyka get-root) get-root/default))
  (import (only (miyka root-p) root/p))
  (import
    (only (scheme base)
          /
          begin
          cond
          define
          list
          newline
          parameterize
          quote))
  (import (only (scheme write) display))
  (cond-expand
    (guile (import (only (srfi srfi-1) remove)))
    (else (import (only (srfi 1) remove))))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin (include-from-path "miyka/miyka.scm")))
    (else (include "miyka.scm"))))
