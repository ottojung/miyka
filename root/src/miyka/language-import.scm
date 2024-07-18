;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define (language:import:directory <path> <new-name>)
  (define interpretation (interpretation/p))
  (define statement (directory-import-statement:make <path> <new-name>))
  (define import-stack (interpretation:import-stack interpretation))
  (stack-push! import-stack statement))

(define (language:import:id <id> <new-name>)
  (define interpretation (interpretation/p))
  (define statement (id-import-statement:make <id> <new-name>))
  (define import-stack (interpretation:import-stack interpretation))
  (stack-push! import-stack statement))

(define (language:import:name <name> <new-name>)
  (define interpretation (interpretation/p))
  (define statement (name-import-statement:make <name> <new-name>))
  (define import-stack (interpretation:import-stack interpretation))
  (stack-push! import-stack statement))

(define-syntax language:import
  (syntax-rules (directory as)
    ((_ directory <path> as <new-name>)
     (language:import:directory <path> <new-name>))
    ((_ id <id> as <new-name>)
     (language:import:id <id> <new-name>))
    ((_ <name> as <new-name>)
     (language:import:name <name> <new-name>))
    ))
