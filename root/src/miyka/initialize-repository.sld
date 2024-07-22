
(define-library
  (miyka initialize-repository)
  (export initialize-repository)
  (import
    (only (euphrates make-directories)
          make-directories))
  (import
    (only (euphrates path-get-dirname)
          path-get-dirname))
  (import
    (only (euphrates random-variable-name)
          random-variable-name))
  (import (only (miyka bin-path) bin:path))
  (import
    (only (miyka call-with-output-file-lazy)
          call-with-output-file/lazy))
  (import (only (miyka home-path) home:path))
  (import (only (miyka id-path) id:path))
  (import
    (only (miyka register-repository-name)
          register-repository-name))
  (import
    (only (miyka repository-bin) repository:bin))
  (import
    (only (miyka repository-home) repository:home))
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
    (only (miyka state-directory-path)
          state-directory:path))
  (import
    (only (scheme base)
          begin
          define
          lambda
          let
          values))
  (import (only (scheme write) display))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/initialize-repository.scm")))
    (else (include "initialize-repository.scm"))))
