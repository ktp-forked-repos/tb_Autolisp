; AREATill.lps - Auftruf:adt,ldt area dtext, l�nge dtext;  L�ngen/Fl�chen von Polilinien in DTEXT Absetzen
;
; Till Jan 2013
;!!! ACHTUNG!!! geht nur, wenn eine Schriftstil mit vorgew�hlter Texth�he gew�hlt wurde!!!


;L�nge in dtext
;
(defun c:ldt(/ laenge pt string ech)
  (setq ech (getvar "CMDECHO"))
  (setvar "CMDECHO" 0)
  
  (princ "\n ")(princ "\n L�ngen PolyLinien-> DTEXT")
  (princ "\n verwendeter Schriftstil muss vorgew�hlte Texth�he haben")
 
 (repeat 20
    (princ "\n ")(princ "\n   Pline picken:") ; Drucke ,neue Zeile 
   
    (command "_.area" "_e" pause)
    (setq laenge(getvar "perimeter")); SysVar f�r Pline-L�nge
  
   (setq pt(getpoint "\n Insertion Point"))

   (setq string(strcat (rtos laenge 2 3) " ,=L")) 	;2 Strings zu einer Stringkette, rtos real to string
													;,=L Kommagetrennt wegen export in csv-Datei
   (command "text" pt "" string)

   );of repeat
  
  (setvar "CMDECHO" ech)
  (princ)
) ;end.

;
; Fl�che Polylinie
;

(defun c:adt(/ area pt ech string)

  ;(setq ech (getvar "CMDECHO")) ;Wozu????
  ;(setvar "CMDECHO" 0)
  
  (princ "\n ")(princ "\n L�ngen PolyLinien -> DTEXT")
   (princ "\n verwendeter Schriftstil muss vorgw�hlte Texth�he haben")(princ "\n")
 
 (repeat 20
    (princ "\n ")(princ "\n Pline picken:")
   
    (command "_.area" "_e" pause)
    (setq area(getvar "area")); SysVar f�r Pline-flaeche
  
   (setq pt(getpoint "\n Insertion Point"))
   
   (setq string(strcat (rtos area 2 3) " ,=A")) ;2 Strings zu einer Stringkette

   (command "text" pt "" string)

   );of repeat
  
  ;(setvar "CMDECHO" ech)
  (princ)
) ;end.


(prompt "; Till Jan 2013 ACHTUNG!!! geht nur, wenn eine Schriftstil mit vorgew�hlter Texth�he gew�hlt wurde!!! < SCHWPK > eingeben zum Starten")