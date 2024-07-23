
(define args
  (cdr (command-line)))

(define code_root (car args))

(display "#! /bin/sh")
(newline)
(flush-all-ports)

(display "exec guile --r7rs -L ")
(write code_root)
(display " -s ")
(write (string-append code_root "/miyka/miyka.sld"))
(display " \"$@\"")
(newline)

(flush-all-ports)
