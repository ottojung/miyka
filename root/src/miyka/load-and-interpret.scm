;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define (load-and-interpret repository path)

  (define env
    (environment
     '(only (scheme write) display)
     '(only (scheme base) begin define newline)
     '(rename (miyka language-install) (language:install install))
     '(rename (miyka language-snapshot) (language:snapshot snapshot))
     '(rename (miyka language-shell) (language:shell shell))
     '(rename (miyka language-detach) (language:detach detach))
     '(rename (miyka language-move-home) (language:move-home move-home))
     '(rename (miyka language-cleanup) (language:cleanup cleanup))
     ))

  (define result
    (make-interpretation))

  (parameterize ((current-repository/p repository)
                 (interpretation/p result))
    (load path env))

  result)
