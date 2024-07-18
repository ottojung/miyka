
(define-library
  (miyka language-import)
  (export language:import)
  (import (only (euphrates stack) stack-push!))
  (import
    (only (miyka import-statement)
          directory-import-statement:make
          id-import-statement:make
          name-import-statement:make))
  (import
    (only (miyka interpretation-p) interpretation/p))
  (import
    (only (miyka interpretation)
          interpretation:import-stack))
  (import
    (only (scheme base)
          _
          begin
          define
          define-syntax
          syntax-rules))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/language-import.scm")))
    (else (include "language-import.scm"))))
