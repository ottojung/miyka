
(define-library
  (miyka interpretation-run-bang)
  (export interpretation:run!)
  (import (only (euphrates box) box-ref))
  (import (only (euphrates fprintf) fprintf))
  (import
    (only (euphrates lines-to-string) lines->string))
  (import (only (euphrates raisu-star) raisu*))
  (import
    (only (euphrates stack)
          stack->list
          stack-empty?
          stack-make
          stack-push!))
  (import (only (euphrates stringf) stringf))
  (import
    (only (euphrates system-star-exit-code)
          system*/exit-code))
  (import
    (only (miyka async-script-path)
          async-script:path))
  (import
    (only (miyka cleanup-wrapper-path)
          cleanup-wrapper:path))
  (import
    (only (miyka command-detach) command:detach?))
  (import
    (only (miyka command-shell)
          command:shell:path
          command:shell?))
  (import
    (only (miyka interpretation-installist)
          interpretation:installist))
  (import
    (only (miyka interpretation)
          interpretation:cleanup
          interpretation:commands
          interpretation:home-moved?
          interpretation:pure?
          interpretation:snapshot?))
  (import
    (only (miyka manifest-path) manifest:path))
  (import
    (only (miyka repository-async-script)
          repository:async-script))
  (import
    (only (miyka repository-cleanup-wrapper)
          repository:cleanup-wrapper))
  (import
    (only (miyka repository-manifest)
          repository:manifest))
  (import
    (only (miyka repository-start-script)
          repository:start-script))
  (import
    (only (miyka save-repository-context)
          save-repository-context))
  (import
    (only (miyka start-script-path)
          start-script:path))
  (import
    (only (miyka start-script-template)
          start-script:template))
  (import
    (only (scheme base)
          and
          append
          apply
          begin
          cond
          define
          else
          for-each
          if
          lambda
          let
          list
          not
          null?
          pair?
          quasiquote
          quote
          reverse
          set!
          string-append
          unless
          unquote
          when))
  (import
    (only (scheme file) call-with-output-file))
  (import (only (scheme write) display write))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/interpretation-run-bang.scm")))
    (else (include "interpretation-run-bang.scm"))))
