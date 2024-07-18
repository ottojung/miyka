
(define-library
  (miyka CLI-import-id)
  (export CLI:import-id)
  (import
    (only (euphrates file-or-directory-exists-q)
          file-or-directory-exists?))
  (import
    (only (euphrates make-temporary-filename)
          make-temporary-filename))
  (import (only (euphrates raisu-fmt) raisu-fmt))
  (import (only (euphrates stringf) stringf))
  (import
    (only (euphrates system-star-exit-code)
          system*/exit-code))
  (import (only (euphrates tilda-a) ~a))
  (import
    (only (miyka CLI-import-directory)
          CLI:import-directory))
  (import (only (miyka get-fetcher) get-fetcher))
  (import
    (only (scheme base)
          =
          begin
          define
          or
          quote
          unless
          when))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/CLI-import-id.scm")))
    (else (include "CLI-import-id.scm"))))
