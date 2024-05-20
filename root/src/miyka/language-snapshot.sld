
(define-library
  (miyka language-snapshot)
  (export language:snapshot)
  (import
    (only (miyka current-repository-p)
          current-repository/p))
  (import
    (only (miyka save-repository-context)
          save-repository-context))
  (import (only (scheme base) begin define))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/language-snapshot.scm")))
    (else (include "language-snapshot.scm"))))
