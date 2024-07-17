
(define-library
  (miyka import-statement)
  (export
    import-statement?
    directory-import-statement:make
    directory-import-statement?
    directory-import-statement:path
    directory-import-statement:new-name)
  (import
    (only (euphrates define-type9) define-type9))
  (import (only (scheme base) begin define or))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/import-statement.scm")))
    (else (include "import-statement.scm"))))
