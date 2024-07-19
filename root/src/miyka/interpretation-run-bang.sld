
(define-library
  (miyka interpretation-run-bang)
  (export interpretation:run!)
  (import
    (only (euphrates absolute-posix-path-q)
          absolute-posix-path?))
  (import (only (euphrates box) box-ref))
  (import (only (euphrates fprintf) fprintf))
  (import
    (only (euphrates lines-to-string) lines->string))
  (import
    (only (euphrates list-collapse) list-collapse))
  (import
    (only (euphrates make-directories)
          make-directories))
  (import (only (euphrates negate) negate))
  (import
    (only (euphrates path-get-dirname)
          path-get-dirname))
  (import (only (euphrates raisu-fmt) raisu-fmt))
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
  (import (only (euphrates tilda-a) ~a))
  (import (only (euphrates tilda-s) ~s))
  (import
    (only (euphrates with-output-stringified)
          with-output-stringified))
  (import
    (only (euphrates words-to-string) words->string))
  (import
    (only (miyka call-with-output-file-lazy)
          call-with-output-file/lazy))
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
    (only (miyka fetcher-var-name) fetcher-var-name))
  (import
    (only (miyka get-fetcher-default)
          get-fetcher/default))
  (import
    (only (miyka get-guix-executable)
          get-guix-executable))
  (import
    (only (miyka guix-executable-env-variable-name)
          guix-executable-env-variable-name))
  (import
    (only (miyka id-map-add-repository-awkscript-path)
          id-map-add-repository-awkscript:path))
  (import
    (only (miyka id-map-add-repository-awkscript-template)
          id-map-add-repository-awkscript:template))
  (import
    (only (miyka import-statement)
          directory-import-statement:new-name
          directory-import-statement:path
          directory-import-statement?
          id-import-statement:new-name
          id-import-statement:value
          id-import-statement?
          name-import-statement:new-name
          name-import-statement:value
          name-import-statement?))
  (import
    (only (miyka interpretation-installist)
          interpretation:installist))
  (import
    (only (miyka interpretation)
          interpretation:cleanup
          interpretation:command
          interpretation:environment
          interpretation:home-moved?
          interpretation:host-stack
          interpretation:import-stack
          interpretation:snapshot?))
  (import
    (only (miyka make-helper-env-script-path)
          make-helper-env-script:path))
  (import
    (only (miyka make-helper-env-script-template)
          make-helper-env-script:template))
  (import
    (only (miyka manifest-path) manifest:path))
  (import
    (only (miyka miyka-version) miyka:version))
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
    (only (miyka repository-id-map-add-repository-awkscript)
          repository:id-map-add-repository-awkscript))
  (import
    (only (miyka repository-make-helper-env-script)
          repository:make-helper-env-script))
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
    (only (miyka repository-versionfile)
          repository:versionfile))
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
    (only (miyka versionfile-path) versionfile:path))
  (import
    (only (scheme base)
          and
          begin
          cond
          define
          else
          equal?
          for-each
          if
          lambda
          let
          list
          list?
          map
          newline
          not
          null?
          or
          quasiquote
          quote
          reverse
          string-append
          unless
          unquote
          when))
  (import (only (scheme eval) environment))
  (import (only (scheme write) display write))
  (cond-expand
    (guile (import (only (srfi srfi-1) filter)))
    (else (import (only (srfi 1) filter))))
  (cond-expand
    (guile (import (only (guile) include-from-path))
           (begin
             (include-from-path
               "miyka/interpretation-run-bang.scm")))
    (else (include "interpretation-run-bang.scm"))))
