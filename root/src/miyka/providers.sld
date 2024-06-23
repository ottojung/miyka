
(define-library
  (miyka providers)
  (export providers)
  (import
    (only (euphrates append-posix-path)
          append-posix-path))
  (import (only (euphrates assoc-or) assoc-or))
  (import
    (only (euphrates properties) define-provider))
  (import (only (euphrates raisu-star) raisu*))
  (import (only (euphrates tilda-a) ~a))
  (import
    (only (miyka get-repositories-directory)
          get-repositories-directory))
  (import
    (only (miyka get-repositories-name-map)
          get-repositories-name-map))
  (import (only (miyka id-path) id:path))
  (import (only (miyka id-value) id:value))
  (import
    (only (miyka repository-id) repository:id))
  (import
    (only (miyka repository-name) repository:name))
  (import
    (only (miyka repository-path) repository:path))
  (import
    (only (miyka repository-state-directory)
          repository:state-directory))
  (import
    (only (miyka repository-work-directory)
          repository:work-directory))
  (import
    (only (miyka work-directory-path)
          work-directory:path))
  (import
    (only (scheme base)
          begin
          define
          lambda
          list
          quote))
  (import
    (only (scheme file) call-with-input-file))
  (import (only (scheme read) read))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin (include-from-path "miyka/providers.scm")))
    (else (include "providers.scm"))))
