
(define-library
  (miyka call-with-output-file-lazy)
  (export call-with-output-file/lazy)
  (import
    (only (euphrates call-with-output-string)
          call-with-output-string))
  (import
    (only (euphrates file-or-directory-exists-q)
          file-or-directory-exists?))
  (import
    (only (euphrates read-string-file)
          read-string-file))
  (import
    (only (scheme base) begin define if lambda when))
  (import
    (only (scheme file) call-with-output-file))
  (import (only (scheme write) display))
  (cond-expand
    (guile (import (only (srfi srfi-13) string=)))
    (else (import (only (srfi 13) string=))))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/call-with-output-file-lazy.scm")))
    (else (include "call-with-output-file-lazy.scm"))))
