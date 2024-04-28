
(define-library
  (miyka check-if-repository-already-exists)
  (export check-if-repository-already-exists)
  (import (only (euphrates stringf) stringf))
  (import (only (miyka raisu-user) raisu/user))
  (import
    (only (miyka repository-exists-in-docker-huh)
          repository:exists-in-docker?))
  (import
    (only (miyka repository-exists-on-disk-huh)
          repository:exists-on-disk?))
  (import
    (only (scheme base)
          begin
          define
          quote
          values
          when))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/check-if-repository-already-exists.scm")))
    (else (include
            "check-if-repository-already-exists.scm"))))
