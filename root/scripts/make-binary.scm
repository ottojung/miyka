
(define args
  (cdr (command-line)))

(define code_root (car args))

(display "#! /bin/sh")
(newline)
(flush-all-ports)

(display "CONTINUATION_SCRIPT=$(mktemp)")
(newline)

(display "guile --r7rs -L ")
(write code_root)
(display " -s ")
(write (string-append code_root "/miyka/miyka.sld"))
(display " --continuation \"$CONTINUATION_SCRIPT\" \"$@\"")
(newline)

(display ". \"$CONTINUATION_SCRIPT\"")
(newline)

(display "exit_code=$?")
(newline)

(display "rm -f \"$CONTINUATION_SCRIPT\"")
(newline)

(display "exit $exit_code")
(newline)
(flush-all-ports)
