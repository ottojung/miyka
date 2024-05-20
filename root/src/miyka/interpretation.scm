;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define-type9 interpretation
  (interpretation-constructor
   installstack
   commands   ;; sequential intstructions run after install step.
   home-moved?
   )
  interpretation?

  (installstack interpretation:installstack)
  (commands interpretation:commands)
  (home-moved? interpretation:home-moved?)
  )


(define (make-interpretation)
  (define installist (stack-make))
  (define commands (stack-make))
  (define home-moved? (make-box #f))
  (interpretation-constructor
   installist
   commands
   home-moved?
   ))
