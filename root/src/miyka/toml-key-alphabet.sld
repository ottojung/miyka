
(define-library
  (miyka toml-key-alphabet)
  (export toml-key/alphabet:has?)
  (import
    (only (euphrates base64-alphabet-minusunderscore)
          base64/alphabet/minusunderscore))
  (import
    (only (euphrates hashmap)
          alist->hashmap
          hashmap-ref))
  (import
    (only (scheme base)
          begin
          cons
          define
          lambda
          let
          map
          vector->list))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/toml-key-alphabet.scm")))
    (else (include "toml-key-alphabet.scm"))))
