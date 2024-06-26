
(define-library
  (miyka interpretation-run-bang)
  (export interpretation:run!)
  (import (only (euphrates box) box-ref))
  (import (only (euphrates fprintf) fprintf))
  (import
    (only (euphrates make-directories)
          make-directories))
  (import
    (only (euphrates path-get-dirname)
          path-get-dirname))
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
  (import (only (euphrates tilda-s) ~s))
  (import
    (only (euphrates words-to-string) words->string))
  (import
    (only (miyka cleanup-wrapper-path)
          cleanup-wrapper:path))
  (import
    (only (miyka command-shell)
          command:shell:path
          command:shell?))
  (import
    (only (miyka enter-script-path)
          enter-script:path))
  (import
    (only (miyka enter-script-template)
          enter-script:template))
  (import
    (only (miyka get-guix-executable)
          get-guix-executable))
  (import
    (only (miyka interpretation-installist)
          interpretation:installist))
  (import
    (only (miyka interpretation)
          interpretation:cleanup
          interpretation:commands
          interpretation:git-stack
          interpretation:home-moved?
          interpretation:host-stack
          interpretation:pure?
          interpretation:snapshot?))
  (import
    (only (miyka manifest-path) manifest:path))
  (import
    (only (miyka relative-path-script-path)
          relative-path-script:path))
  (import
    (only (miyka relative-path-script-template)
          relative-path-script:template))
  (import
    (only (miyka repository-cleanup-wrapper)
          repository:cleanup-wrapper))
  (import
    (only (miyka repository-enter-script)
          repository:enter-script))
  (import
    (only (miyka repository-manifest)
          repository:manifest))
  (import
    (only (miyka repository-relative-path-script)
          repository:relative-path-script))
  (import
    (only (miyka repository-run-script)
          repository:run-script))
  (import
    (only (miyka repository-run-sync-script)
          repository:run-sync-script))
  (import
    (only (miyka repository-setup-script)
          repository:setup-script))
  (import
    (only (miyka repository-teardown-script)
          repository:teardown-script))
  (import
    (only (miyka run-script-path) run-script:path))
  (import
    (only (miyka run-script-template)
          run-script:template))
  (import
    (only (miyka run-sync-script-path)
          run-sync-script:path))
  (import
    (only (miyka setup-script-path)
          setup-script:path))
  (import
    (only (miyka teardown-script-path)
          teardown-script:path))
  (import
    (only (scheme base)
          begin
          cond
          define
          else
          for-each
          if
          lambda
          let
          list
          map
          newline
          null?
          quasiquote
          quote
          reverse
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
