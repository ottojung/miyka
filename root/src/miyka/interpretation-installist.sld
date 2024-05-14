
(define-library
  (miyka interpretation-installist)
  (export interpretation:installist)
  (import (only (euphrates stack) stack->list))
  (import
    (only (miyka interpretation)
          interpretation:installstack))
  (import
    (only (scheme base) begin define reverse))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/interpretation-installist.scm")))
    (else (include "interpretation-installist.scm"))))
