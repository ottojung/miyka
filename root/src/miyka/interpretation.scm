;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define-type9 interpretation
  (interpretation-constructor
   installstack
   command          ;; shell scripts that is run after package installation and setup.
   home-moved?      ;; whether $HOME shall be set.
   cleanup          ;; path to the cleanup script.
   snapshot?        ;; whether to snapshot before open or not.
   environment      ;; restrict environment to listed variables, or inherit all if not set.
   host-stack       ;; files that are linked from host.
   git-stack        ;; repositories to-be deployed.
   )

  interpretation?

  (installstack interpretation:installstack)
  (command interpretation:command)
  (home-moved? interpretation:home-moved?)
  (cleanup interpretation:cleanup)
  (snapshot? interpretation:snapshot?)
  (environment interpretation:environment)
  (host-stack interpretation:host-stack)
  (git-stack interpretation:git-stack)
  )


(define (make-interpretation)
  (define installist (stack-make))
  (define command (make-box #f))
  (define home-moved? (make-box #f))
  (define cleanup (make-box #f))
  (define snapshot? (make-box #f))
  (define environment (make-box #f))
  (define host-stack (stack-make))
  (define git-stack (stack-make))

  (interpretation-constructor
   installist
   command
   home-moved?
   cleanup
   snapshot?
   environment
   host-stack
   git-stack
   ))
