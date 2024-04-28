
(define-library
  (miyka get-current-editor)
  (export get-current-editor)
  (import (only (euphrates raisu-fmt) raisu-fmt))
  (import
    (only (euphrates system-environment)
          system-environment-get))
  (import
    (only (scheme base) begin define or quote))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/get-current-editor.scm")))
    (else (include "get-current-editor.scm"))))
