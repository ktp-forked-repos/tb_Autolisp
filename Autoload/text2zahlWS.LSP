;;;    ____________________________________________________________   
;;;  |                                                             
;;;  |  - Zerlegen von Textstrings in vorkommende Zahlenwerte     
;;;  |____________________________________________________________ 
;;;  |                                                             
;;;  |    Aufruf:  (text2zahl [String] [FLAG])                     
;;;  |                                                             
;;;  |    Eingangswerte: Textstring zum Zerlegen                   
;;;  |                    Flag T -> Komma wird als Trennung         
;;;  |                              zwischen Zahlen angesehen       
;;;  |                        NIL -> Komma als Tausendertrennung   
;;;  |                                                             
;;;  |    Ausgangswerte: Liste mit allen vorkommenden Zahlen       
;;;  |                                                             
;;;  |    Beispiel:                                               
;;;  |    (text2zahl "ASDF 130,232.54564656 -25" T) liefert:       
;;;  |      -> (130233.0 -25)                                       
;;;  |    (text2zahl "ASDF 130,232.54564656 -25" nil) liefert:     
;;;  |      -> (130 232.546 -25)                                   
;;;  |                                                             
;;;  |  - Wolfgang S�nder                                         
;;;  |  - Version 1.0                                             
;;;  |  - Sept 2007                                               
;;;  |                      
;;;  |____________________________________________________________ 
;;;                                                                   

(defun text2zahl (String KOMMAFlAG / LISTE RESTLIST TEMP ZAHLENLIST)
  (setq restlist  (vl-string->list string)
zahlenlist (append (vl-string->list "1234567890+-.")
  (if KOMMAFLAG
    (vl-string->list ",")
  )
  )
  )
  (while restlist
    (while (not (member (car restlist) zahlenlist))
      (setq restlist (cdr restlist))
    )
    (while (member (car restlist) zahlenlist)
      (setq temp    (cons (car restlist) temp)
    restlist (cdr restlist)
      )
    )
    (if temp
      (setq liste (cons
    (if KOMMAFLAG
      (vl-string-subst
""
","
(vl-list->string (reverse temp))
      )
      (vl-list->string (reverse temp))
    )
    liste
  )
    temp  nil
      )
    )
  )
  (mapcar 'read
  (reverse liste)
  )
;;;mit read in Zahlen umwandeln, Int oder Real wird von read selektiert
)