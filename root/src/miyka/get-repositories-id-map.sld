
(define-library
  (miyka get-repositories-id-map)
  (export get-repositories-id-map)
  (import (only (euphrates assoc-or) assoc-or))
  (import
    (only (euphrates file-or-directory-exists-q)
          file-or-directory-exists?))
  (import (only (euphrates raisu-fmt) raisu-fmt))
  (import (only (euphrates raisu-star) raisu*))
  (import (only (euphrates stringf) stringf))
  (import (only (euphrates tilda-a) ~a))
  (import
    (only (miyka get-repositories-id-map-path)
          get-repositories-id-map-path))
  (import
    (only (miyka parse-toml-file) parse-toml-file))
  (import
    (only (scheme base)
          begin
          cons
          define
          lambda
          let
          list
          map
          quote
          unless
          vector
          vector->list))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/get-repositories-id-map.scm")))
    (else (include "get-repositories-id-map.scm"))))
