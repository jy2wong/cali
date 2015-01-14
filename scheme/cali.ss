#lang racket/base

(require racket/list)
(require racket/match)
(require racket/string)
(provide cali)

(struct calicmd (from to at dur start end event) #:mutable #:transparent)
(struct calidate (every? dayofweek month daynum year) #:transparent)
(struct calitime (hours minutes ampm) #:transparent)

(define (cali)
  (parse-command (vector->list (current-command-line-arguments))))

(define (prettify C)
  (pretty-time "from" (calicmd-from C))
  (pretty-time "to" (calicmd-to C))
  (pretty-time "at" (calicmd-at C))
  (pretty-time "dur" (calicmd-dur C))
  (pretty-date "start" (calicmd-start C))
  (pretty-date "end" (calicmd-end C))
  (printf "~nevent: ~a~n" (calicmd-event C))
  (printf "---~n")
)

(define (pretty-time label time)
  (cond [(not (empty? time))
         (printf "~a: ~a~n" label time)]
        [else empty]))

(define (pretty-date label date)
  (cond [(not (empty? date))
         (printf "~a: ~a~n" label date)]
        [else empty]))

(define sanitize-dayofweek
  (match-lambda
    [(or "mon" "monday")    1]
    [(or "tue" "tuesday")   2]
    [(or "wed" "wednesday") 3]
    [(or "thu" "thursday")  4]
    [(or "fri" "friday")    5]
    [(or "sat" "saturday")  6]
    [(or "sun" "sunday")    7]
    [(or "tod" "today")     'today]
    [(or "tom" "tomorrow")  'tomorrow]
    [_                      #f]))

(define sanitize-month
  (match-lambda
    [(or "jan" "january")          1]
    [(or "feb" "february")         2]
    [(or "mar" "march")            3]
    [(or "apr" "april")            4]
    [    "may"                     5]
    [(or "jun" "august")           6]
    [(or "jul" "august")           7]
    [(or "aug" "august")           8]
    [(or "sep" "september" "sept") 9]
;    [(regexp #rx"sep(t|tember)?")  9]
    [(or "oct" "october")          10]
    [(or "nov" "november")         11]
    [(or "dec" "december")         12]
    [_                             #f]))

(define (sanitize-daynum N)
  (cond
    [(not (string->number N)) #f]
    [(<= 1 (string->number N) 31) (string->number N)]
    [else                     #f]))

(define (sanitize-year y)
  (string->number y))

(define (parse-date lst)
  (match-let*
    ([rst lst]
;     [(regexp #rx"(every)? gg
     [(list-rest (and "every" every) ... rst) rst]
     [(list-rest (app sanitize-dayofweek
                   (and (not #f) dayofweek)) ...
                 rst)
      rst]
     [(list-rest (app sanitize-month
                   (and (not #f) month)) ...
                 rst)
      rst]
     [(list-rest (app sanitize-daynum
                  (and (not #f) daynum)) ...
                 rst)
      rst]
     [(list-rest (app sanitize-year
                  (and (not #f) year)) ...
                 rst)
      rst]
    )
	;(if (not (empty? every)) (printf "every ") #t)
	;(printf "dayofweek: ~a month: ~a daynum: ~a year: ~a~n" dayofweek month daynum year)
    (list (if (equal? lst rst)
              #f
              (calidate (not (empty? every)) dayofweek month daynum year))
          rst)
  )
)

(define (parse-time str)
  (match str
    [(list-rest "noon" rst)
     (list (calitime 12 0 "am") rst)]
    [(list-rest (or "mid" "midnight") rst)
     (list (calitime 0 0 "am") rst)]
; am or pm with no space
    [(list-rest (regexp #rx"([10]?[1-9])(:)([0-5][0-9])([ap]m)" (list _ hours ":" minutes ampm))
                rst)
    ;(printf "timeb[~a : ~a ~a]~n" hours minutes ampm)
    (list (calitime (string->number hours) (string->number minutes) ampm) rst)]
; am or pm with a space
    [(list-rest (regexp #rx"([10]?[1-9])(:)([0-5][0-9])" (list _ hours ":" minutes))
                (and ampm (or "am" "pm"))
                rst)
    ;(printf "timec[~a : ~a ~a]~n" hours minutes ampm)
     (list (calitime (string->number hours) (string->number minutes) ampm) rst)]
; no am or pm
    [(list-rest (regexp #rx"([10]?[1-9])(:)([0-5][0-9])" (list _ hours ":" minutes))
                rst)
    ;(printf "timed[~a : ~a ~a]~n" hours minutes #f)
     (list (calitime (string->number hours) (string->number minutes) #f) rst)]
; no minutes
    [(list-rest (regexp #rx"([210]?[1-9])([ap]m)?" (list _ hours ampm))
                rst)
    ;(printf "timea[~a : ~a ~a]~n" hours 0 ampm)
     (list (calitime (string->number hours) 0 ampm) rst)]
    [_ (list empty str)]
  )
)

(define (parse-command str)
;  (let* ([lst (string-split str)]
  (let* ([lst str]
         [C (calicmd empty empty empty empty empty empty "")]
         [x (parse-date lst)])
        (cond [(first x) (set-calicmd-at! C (cons (first x) (calicmd-at C)))
                         (parse-command2 C (second x)) ]
              [else            (parse-command2 C lst)])
        (printf "string: [~a]~n" str)
        (prettify C))
)

(define (parse-command2 C lst)
  (match lst
    ['() #t]
    [(list-rest "-" rst)    (set-calicmd-event! C (string-join (rest lst)))]
    [(list-rest "from" rst) (let ([x (parse-time (rest lst))])
                              (set-calicmd-from! C (cons (first x) (calicmd-from C)))
                              (parse-command2 C (second x))) ]
    [(list-rest "to" rst)   (let ([x (parse-time (rest lst))])
                              (set-calicmd-to! C (cons (first x) (calicmd-to C)))
                              (parse-command2 C (second x))) ]
    [(list-rest "at" rst)   (let ([x (parse-time (rest lst))])
                              (set-calicmd-at! C (cons (first x) (calicmd-at C)))
                              (parse-command2 C (second x))) ]
    [(list-rest "starting" rst) (let ([x (parse-date (rest lst))])
                              (set-calicmd-start! C (cons (first x) (calicmd-start C)))
                              (parse-command2 C (second x))) ]
    [(list-rest "ending" rst) (let ([x (parse-date (rest lst))])
                              (set-calicmd-end! C (cons x (calicmd-end C)))
                              (parse-command2 C (second x))) ]
;    [(list-rest "starting" rst) (let ([x (parse-date (rest lst))])
;                              (set-calicmd-start! C (cons (first x) (calicmd-start C)))
;                              (parse-command2 C (second x))) ]
    [ _                     (printf "no match: ~a,~a~n"
                                    (length lst) lst)]))

(cali)

;; tests
;(print (calicmd-to C))
;(parse-command "at 5")
;(parse-command "at 5pm")
;(parse-command "at 14:59")
;(parse-command "at 2:00am")
;(parse-command "at noon")
;(parse-command "at midnight")
;(parse-command "at mid")
;(parse-command "friday at 5")
;(parse-command "every friday at 5")
;(parse-command "every tuesday at 5 starting october 25")
;(parse-command "every tuesday at 5 ending october 25")
;(parse-command "every monday wednesday fri at 11:30am starting september 1 2012 ending jan 1 2013")
;(parse-command "every monday wednesday fri from 11:30am to 12:20pm starting september 1 2012 ending jan 1 2013")
;(parse-command "from 11:30am to 12:20pm")
;(parse-command "from 11:30 am to 12:20 pm")
;(parse-command "tuesday - take out the trash")

; vim: ft=scheme:et:sw=2:ts=2:sts=2:tw=80
