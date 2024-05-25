;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define-type9 interpretation
  (interpretation-constructor
   installstack
   commands   ;; sequential intstructions run after install step.
   home-moved?
   cleanup    ;; path to the cleanup script.
   snapshot?  ;; whether to snapshot before open or not.
   pure?      ;; whether to use --pure with guix.
   host-stack ;; files that are linked from host.
   git-stack  ;; repositories to-be deployed.
   )

  interpretation?

  (installstack interpretation:installstack)
  (commands interpretation:commands)
  (home-moved? interpretation:home-moved?)
  (cleanup interpretation:cleanup)
  (snapshot? interpretation:snapshot?)
  (pure? interpretation:pure?)
  (host-stack interpretation:host-stack)
  (git-stack interpretation:git-stack)
  )


(define (make-interpretation)
  (define installist (stack-make))
  (define commands (stack-make))
  (define home-moved? (make-box #f))
  (define cleanup (make-box #f))
  (define snapshot? (make-box #f))
  (define pure? (make-box #t))
  (define host-stack (stack-make))
  (define git-stack (stack-make))

  (interpretation-constructor
   installist
   commands
   home-moved?
   cleanup
   snapshot?
   pure?
   host-stack
   git-stack
   ))
