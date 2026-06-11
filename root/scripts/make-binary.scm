
(define args
  (cdr (command-line)))

(define code_root (car args))

(display "#! /bin/sh")
(newline)
(flush-all-ports)

(display "CONTINUATION_SCRIPT=$(mktemp)")
(newline)

(display "trap 'rm -f \"$CONTINUATION_SCRIPT\"' EXIT HUP INT QUIT ABRT KILL ALRM TERM")
(newline)

(display "MIYKA_TEMPORARY_CONTINUATION=\"$CONTINUATION_SCRIPT\" guile --r7rs -L ")
(write code_root)
(display " -s ")
(write (string-append code_root "/miyka/miyka.sld"))
(display " \"$@\" && sh -- \"$CONTINUATION_SCRIPT\"")
(newline)
(flush-all-ports)
