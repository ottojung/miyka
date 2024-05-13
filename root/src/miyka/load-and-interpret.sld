
(define-library
  (miyka load-and-interpret)
  (export load-and-interpret)
  (import (only (euphrates stack) stack-make))
  (import
    (only (miyka current-repository-p)
          current-repository/p))
  (import
    (only (miyka install-list-p) install-list/p))
  (import
    (only (miyka language-install) language:install))
  (import
    (only (miyka language-start) language:start))
  (import
    (only (scheme base)
          begin
          define
          newline
          parameterize
          quote))
  (import (only (scheme eval) environment))
  (import (only (scheme load) load))
  (import (only (scheme write) display write))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/load-and-interpret.scm")))
    (else (include "load-and-interpret.scm"))))
