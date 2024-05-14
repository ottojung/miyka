
(define-library
  (miyka load-and-interpret)
  (export load-and-interpret)
  (import
    (only (miyka current-repository-p)
          current-repository/p))
  (import
    (only (miyka interpretation-p) interpretation/p))
  (import
    (only (miyka interpretation) make-interpretation))
  (import
    (only (miyka language-install) language:install))
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
