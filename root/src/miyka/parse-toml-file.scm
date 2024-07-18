;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define (parse-toml-file path)
  ;; TODO: upgrade to full support of TOML. Probably needs a rewrite in parselynn.
  ;; TODO: move to euphrates.

  (define lines (read/lines path))

  (define (check-name-characters chars)
    (define illegal-characters
      (filter
       (lambda (c)
         (not (toml-key/alphabet:has? c)))
       chars))

    (unless (null? illegal-characters)
      (raisu* :from "parse-toml-file"
              :type 'toml-parse-error
              :message (stringf "Illegal characters in TOML name ~s: ~s."
                                chars illegal-characters)
              :args (list chars illegal-characters))))

  (define (parse-table-title line)
    (define chars (string->list line))

    (unless (string-suffix? "]]" line)
      (raisu* :from "parse-toml-file"
              :type 'toml-parse-error
              :message (stringf "Unexpected ending of table title: ~s." line)
              :args (list line path)))

    (let ()
      (define title-chars
        (reverse
         (list-drop-n
          2
          (reverse
           (list-drop-n
            2 chars)))))

      (check-name-characters title-chars)
      (string->symbol (list->string title-chars))))

  (define (parse-key line)
    (define parts
      (call-with-input-string
       line read-list))

    (unless (equal? 3 (length parts))
      (raisu* :from "parse-toml-file"
              :type 'toml-parse-error
              :message (stringf "Bad key line ~s expected 3 parts, but got ~s."
                                line (length parts))
              :args (list line (length parts) parts)))

    (let ()
      (define-tuple (key eq value) parts)

      (unless (equal? '= eq)
        (raisu* :from "parse-toml-file"
                :type 'toml-parse-error
                :message (stringf "Expected equal sign in a TOML field ~s." line)
                :args (list line parts)))

      (unless (or (string? value) (number? value))
        (raisu* :from "parse-toml-file"
                :type 'toml-parse-error
                :message (stringf "Expected string or number in a TOML field value ~s." line)
                :args (list line value parts)))

      (check-name-characters (string->list (~a key)))

      (cons key value)))

  (define (parse-table line lines)
    (define title (parse-table-title line))
    (define-values (table-lines next-lines)
      (list-span-while
       (lambda (line) (not (string-prefix? "[" line)))
       lines))

    (define table-keys
      (map parse-key table-lines))

    (define table
      (cons title table-keys))

    (values table next-lines))

  (define (add-array-table table ret)
    (define-pair (title table-keys) table)
    (define existing (assoc-or title ret (vector)))
    (define new
      (list->vector
       (append
        (vector->list existing)
        (list table-keys))))
    (assoc-set-value title new ret))

  (define trimmed-lines
    (map
     (lambda (line)
       (string-trim-chars line (list #\space #\tab) 'both))
     lines))

  (define no-empty-lines
    (filter
     (negate string-null-or-whitespace?)
     trimmed-lines))

  (let loop ((ret '())
             (lines no-empty-lines))

    (if (null? lines) ret
        (let ()
          (define line (car lines))

          (cond
           ((string-prefix? "[[" line)
            (let ()
              (define-values (table next-lines) (parse-table line (cdr lines)))
              (define new-ret (add-array-table table ret))
              (loop new-ret next-lines)))

           (else
            (raisu* :from "parse-toml-file"
                    :type 'toml-parse-error
                    :message (stringf "Unexpected line during parsing of TOML: ~s." line)
                    :args (list line lines path ret))))))))
