
(define-library
  (miyka touch-file)
  (export touch-file)
  (import
    (only (euphrates file-or-directory-exists-q)
          file-or-directory-exists?))
  (import
    (only (scheme base) begin define lambda unless))
  (import
    (only (scheme file) call-with-output-file))
  (import (only (scheme write) display))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/touch-file.scm")))
    (else (include "touch-file.scm"))))
