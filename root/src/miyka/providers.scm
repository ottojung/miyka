;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define providers #t)

(define-provider p:id:path
  :targets (id:path)
  :sources (repository:work-directory)
  (lambda (this)
    (define wd (repository:work-directory this))
    (define wd-path (work-directory:path wd))
    (append-posix-path wd-path "id.txt")))

(define-provider p:id:value/1
  :targets (id:value)
  :sources (id:path)
  (lambda (this)
    (define path (id:path this))
    (~a (call-with-input-file path read))))

(define-provider p:possible-ids:1
  :targets (repository:possible-ids)
  :sources (id:value)
  (lambda (this)
    (list this)))

(define-provider p:possible-ids:2
  :targets (repository:possible-ids)
  :sources (repository:name)
  (lambda (this)
    (define id-map (get-repositories-id-map))
    (define name (repository:name this))

    (define id-values
      (map
       car
       (filter
        (lambda (pp)
          (equal? name (cdr pp)))
        id-map)))

    id-values))

(define-provider p:id:value/2
  :targets (id:value)
  :sources (repository:possible-ids)
  (lambda (this)
    (define name
      (repository:name this))
    (define id-values
      (repository:possible-ids this))

    (when (null? id-values)
      (raisu* :from "id:value"
              :type 'bad-name
              :message "Bad name."
              :args (list name id-values this)))

    (unless (null? (cdr id-values))
      (raisu* :from "id:value"
              :type 'multiple-names
              :message "Name corresponds to multiple repositories."
              :args (list name id-values this)))

    (car id-values)))

(define-provider p:repository:work-directory
  :targets (repository:work-directory)
  :sources (repository:path)
  (lambda (this)
    (define repo-path (repository:path this))
    (append-posix-path repo-path "wd")))

(define-provider p:repository:path
  :targets (repository:path)
  :sources (id:value)
  (lambda (this)
    (define repos-dir (get-repositories-directory))
    (define id (repository:id this))
    (define id-value (id:value id))
    (define path (append-posix-path repos-dir id-value))
    path))

(define-provider p:repository:state-directory
  :targets (repository:state-directory)
  :sources (repository:path)
  (lambda (this)
    (define parent (repository:work-directory this))
    (define parent-path (work-directory:path parent))
    (append-posix-path parent "state")))
