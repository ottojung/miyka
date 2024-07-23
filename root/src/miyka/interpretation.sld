
(define-library
  (miyka interpretation)
  (export
    make-interpretation
    interpretation?
    interpretation:installstack
    interpretation:command
    interpretation:home-moved?
    interpretation:cleanup
    interpretation:snapshot?
    interpretation:environment
    interpretation:import-stack)
  (import (only (euphrates box) make-box))
  (import (only (euphrates stack) stack-make))
  (import
    (only (scheme base)
          =
          and
          begin
          car
          define
          equal?
          length
          quote
          vector
          vector-ref
          vector?))
  (import (only (scheme eval) environment))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/interpretation.scm")))
    (else (include "interpretation.scm"))))
