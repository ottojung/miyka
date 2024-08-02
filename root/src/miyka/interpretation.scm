;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define interpretation:tag
  '*miyka-interpreation*)

(define (interpretation:constructor
         installstack     ;; programs to install.
         command          ;; shell script that is run after package installation and setup.
         cleanup          ;; path to the cleanup script.
         snapshot?        ;; whether to snapshot before open or not.
         environment      ;; restrict environment to listed variables, or inherit all if not set.
         import-stack     ;; repositories to-be imported.
         )

  (vector
   interpretation:tag
   installstack
   command
   cleanup
   snapshot?
   environment
   import-stack
   ))

(define (interpretation? object)
  (and (vector? object)
       (= 11 (length object))
       (equal? interpretation:tag (car object))))

(define (interpretation:installstack interpretation)
  (vector-ref interpretation 1))

(define (interpretation:command interpretation)
  (vector-ref interpretation 2))

(define (interpretation:cleanup interpretation)
  (vector-ref interpretation 3))

(define (interpretation:snapshot? interpretation)
  (vector-ref interpretation 4))

(define (interpretation:environment interpretation)
  (vector-ref interpretation 5))

(define (interpretation:import-stack interpretation)
  (vector-ref interpretation 6))

(define (make-interpretation)
  (define installist (stack-make))
  (define command (make-box #f))
  (define cleanup (make-box #f))
  (define snapshot? (make-box #f))
  (define environment (make-box #f))
  (define import-stack (stack-make))

  (interpretation:constructor
   installist
   command
   cleanup
   snapshot?
   environment
   import-stack
   ))
