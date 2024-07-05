
(define-library
  (miyka create-file)
  (export create-file)
  (import
    (only (euphrates file-or-directory-exists-q)
          file-or-directory-exists?))
  (import
    (only (miyka call-with-output-file-lazy)
          call-with-output-file/lazy))
  (import
    (only (scheme base) begin define lambda unless))
  (import (only (scheme write) display))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/create-file.scm")))
    (else (include "create-file.scm"))))
