;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define (language:run image)

  (define container
    (string-append
     "miyka_"
     (random-variable-name 10)))

  (define name (container:name container))

  (define result
    (system*/exit-code
     "docker" "run"
     "--interactive"
     "--tty"
     "--rm"
     "--name" name
     image
     ))

  (values))
