;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define ps-script:template "

function transitive_closure(graph, path, pid) {
    if (pid in path) {
        return 0 ;
    }

    path[pid] = 1 ;
    for (child in graph[pid]) {
        transitive_closure(graph, path, child) ;
    }
}

BEGIN {
    plist[0] = 1 ;
}

{
    ptable[$1][$2] = 1 ;
    ctable[$2][$1] = 1 ;
    plist[length(plist)] = $1 ;
}

END {
   split(OLD_PIDS_STR, OLD_PIDS, \"\\n\") ;
   split(NEW_PIDS_STR, NEW_PIDS, \"\\n\") ;
   split(EXC_PIDS_STR, EXC_PIDS, \"\\n\") ;

   for (i in OLD_PIDS) {
       pid = OLD_PIDS[i]
       if (pid != \"\") {
           transitive_closure(ptable, pkeep, pid) ;
       }
   }

   for (i in NEW_PIDS) {
       pid = NEW_PIDS[i]
       if (pid != \"\") {
           transitive_closure(ctable, ckeep, pid) ;
       }
   }

   for (i in EXC_PIDS) {
       pid = EXC_PIDS[i]
       keep[pid] = 1 ;
   }

   for (pid in pkeep) {
       keep[pid] = 1 ;
   }

   for (pid in ckeep) {
       keep[pid] = 1 ;
   }

   for (i = 1 ; i < length(plist) ; i++) {
       pid = plist[i] ;
       if (pid in keep) {
       } else {
           print pid ;
       }
   }
}

")
