
(define-library
  (miyka parse-toml-file)
  (export parse-toml-file)
  (import (only (euphrates assoc-or) assoc-or))
  (import
    (only (euphrates assoc-set-value)
          assoc-set-value))
  (import
    (only (euphrates call-with-input-string)
          call-with-input-string))
  (import
    (only (euphrates define-pair) define-pair))
  (import
    (only (euphrates define-tuple) define-tuple))
  (import
    (only (euphrates list-drop-n) list-drop-n))
  (import
    (only (euphrates list-span-while)
          list-span-while))
  (import (only (euphrates negate) negate))
  (import (only (euphrates raisu-star) raisu*))
  (import (only (euphrates read-lines) read/lines))
  (import (only (euphrates read-list) read-list))
  (import
    (only (euphrates string-null-or-whitespace-p)
          string-null-or-whitespace?))
  (import
    (only (euphrates string-trim-chars)
          string-trim-chars))
  (import (only (euphrates stringf) stringf))
  (import (only (euphrates tilda-a) ~a))
  (import
    (only (miyka toml-key-alphabet)
          toml-key/alphabet:has?))
  (import
    (only (scheme base)
          =
          append
          begin
          car
          cdr
          cond
          cons
          define
          define-values
          else
          equal?
          if
          lambda
          length
          let
          list
          list->string
          list->vector
          map
          not
          null?
          number?
          or
          quote
          reverse
          string->list
          string->symbol
          string?
          unless
          values
          vector
          vector->list))
  (cond-expand
    (guile (import (only (srfi srfi-1) filter)))
    (else (import (only (srfi 1) filter))))
  (cond-expand
    (guile (import
             (only (srfi srfi-13)
                   string-prefix?
                   string-suffix?)))
    (else (import
            (only (srfi 13) string-prefix? string-suffix?))))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path "miyka/parse-toml-file.scm")))
    (else (include "parse-toml-file.scm"))))
