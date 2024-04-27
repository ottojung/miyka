
(define-library
  (miyka raisu-user)
  (export raisu/user)
  (import (only (euphrates raisu-star) raisu*))
  (import (only (scheme base) begin define list))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/raisu-user.scm")))
    (else (include "raisu-user.scm"))))
