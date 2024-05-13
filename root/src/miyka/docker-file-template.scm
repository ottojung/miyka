;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define docker-file-template
  "
FROM debian:12

RUN apt-get update

RUN apt-get install -y guix

RUN useradd --create-home miykauser

USER miykauser

WORKDIR /home/miykauser

COPY channels.scm .local/share/miyka/channels.scm
COPY manifest.scm .local/share/miyka/manifest.scm

RUN guix time-machine \
         --channels='.local/share/miyka/channels.scm' \
         -- \
         package --manifest='.local/share/miyka/manifest.scm'

CMD bash --login

"
  )
