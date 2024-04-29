;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define (do-docker-build dockerfile)
  (define path (dockerfile:path dockerfile))
  (define repository (dockerfile:repository dockerfile))
  (define build-context-dir (repository:build-context-dir repository))
  (define image (dockerfile:image dockerfile))
  (define tag (image:tag image))

  (define _1
    (make-directories build-context-dir))

  (define result
    (system*/exit-code
     "docker" "build"
     "--file" path
     "--tag" tag
     build-context-dir))

  (unless (= 0 result)
    (raisu-fmt 'docker-build-failed
               "Docker build failed for repository ~s." repository))

  (values))
