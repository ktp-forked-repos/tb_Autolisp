; Fl�chentr�gkeit aus SCHwerpkt, Aufruf flt  c. by TB                          
; 
; Berechnet die Fl�chentr�gheitsmomente o. Steiner Anteil einer Polylinie/Region 
;und markiert ihn mit einem Punkt 
; 
; Aufruf: flt
;
;

(defun REGKEY_R (/ KEY) 
  (setq key (vl-registry-read
              (strcat 
                "HKEY_CURRENT_USER\\"
                (vlax-product-key)
                "\\Profiles\\"
                (getvar "CProfile")
                "\\"
                "General Configuration"
                ) ;_ end of strcat
              "TempDirectory"
              ) ;_ end of vl-registry-read
        ) ;_ end of setq
  (eval key)
  )	;_ end of defun

(defun sichvar () 
  (setq cmdakt (getvar "cmdecho")) 
  (setq osmakt (getvar "osmode")) 
  (setq filedakt (getvar "filedia")) 
  (setq layakt (getvar "clayer")) 
  (setq alterr *error*) 
  (setq blipakt (getvar "blipmode")) 
  (setq delakt (getvar "delobj")) 
  (setq lupakt (getvar "luprec")) 
  (setq pdakt (getvar "pdmode")) 
 )	;ende defun 


(defun restvar ()
  (setvar "cmdecho" cmdakt) 
  (setvar "osmode" osmakt) 
  (setvar "filedia" filedakt) 
  (setvar "clayer" layakt) 
  (setq *error* alterr) 
  (setvar "blipmode" blipakt) 
  (setvar "delobj" delakt) 
  (setvar "luprec" lupakt) 
  (setvar "pdmode" pdakt) 
 )	;ende defun 


(defun neuerr (s) 		; Abfangfunktion
  (if (/= s "Funktion abgebrochen") 
    (princ (strcat "\nFehler: " s))  
    ) 
  (if mprdat(close mprdat))  
  (command "_undo" "_BACK")  
  (restvar)  
  (print)  
 )	;ende defun


(DEFUN koord (item arg / len pos zeich str)  		 ;Definition koord (item arg) globale Variablen, ( len pos) lokale Variablen 
  (if (setq posi					 ;var posi = position des Zeichens "X:" 
	     (vl-string-position (ascii arg) item) 	 ;ascii 
		)  				   	 ;Looks for a character with the specified ASCII code in a string, gibt Zeichenposition zur�ck
      (atof(substr item (+ 4 posi))) 			 ;atof konvertiert String in Realzahl 
    ) 	;close if 	; substr "Wort" 2 
   	;(print posi) 
  )	;ende defun 


(DEFUN koord2 (item2 arg2 / len pos zeich str)  	 ;Definition koord (item arg) globale Variablen, ( len pos) lokale Variablen 
  (if (setq posi					 ;var posi = position des Zeichens "X:" 
	     (vl-string-position (ascii arg2)item2)   	 ;ascii 
		)  				   	 ;Looks for a character with the specified ASCII code in a string, gibt Zeichenposition zur�ck
      (atof(substr item2 (+ 28 posi))) 			 ;atof konvertiert String in Realzahl 
    ) 	;close if 	; substr "Wort" 2 
   	;(print posi) 
  )	;ende defun 

 


(defun c:flt ( / mprdat p1 xs ys datei p2 alterr cmdakt osmakt filedakt layakt 
		as el kont e1  ptBauteil ) 
  (vl-load-com) 
  (command "_undo" "_MARK")
  (sichvar) 
  (setvar "osmode" 0) 
  (setvar "cmdecho" 0) 
  (setvar "luprec" 8) 
  (setvar "pdmode" 3) 
  (setq *error* neuerr) 
  (setq el (entlast)) 
  (setq as (ssadd))
    
  (setq p1 (getpoint "\nin die zu berechnende Fl�che klicken")) 
  (command "-umgrenzung" "o" "i" "j" "o" "r" "x" p1 "") 
  (setq e1 (entnext el)) 
  (setq datei (strcat (REGKEY_R) "test.mpr")) 
  (while e1
    (ssadd e1 as) 
    (setq e1 (entnext e1)) 
    )
  (setq kont (ssname as 0)) 
  (ssdel kont as)  
  (command "_massprop" "_l" "" "_Y" datei) 
  ;(command "_.erase" "_l" "")	  ;_l steht f�r last
  (setq mprdat (open datei "r")) 

  (repeat 3			;hiermit wird die Textzeile bestimmt !!
    (read-line mprdat) 
    (print) 
    )
  (setq Area (koord2 (strcase (read-line mprdat)) "Fl�che:"))

  (repeat 3 			;hiermit wird die Textzeile bestimmt !!
    (read-line mprdat)
    (print) 
    )
  
  (setq xs (koord (strcase (read-line mprdat)) "X:")) 
  (setq ys (koord (strcase (read-line mprdat)) "Y:"))  
  (setq Ixx (koord (strcase (read-line mprdat)) "X:"))
  (setq Iyy (koord (strcase (read-line mprdat)) "Y:"))
  (setq Ixxyy (koord (strcase (read-line mprdat)) "XY:"))
  
  (close mprdat) 
  (setq p2 (list xs ys))	 	;list durch Leerzeichen getrennt
  (vl-file-delete datei)
  (command "_point" p2)  
  (restvar) 
  (princ) 

; Calculation of moment of inertia without Steiner part
  (setq IxoSA (- Ixx (* Area (expt ys 2)))) 
  (setq IyoSA (- Iyy (* Area (expt xs 2)))) 
  (setq IxyoSA (+  Ixxyy (* Area xs ys))) 


  ; counter for FLT calls 
  ; (setq fcall (if fcall (1+ fcall) 1))
  ;(setq fcallstring (rtos fcall 2 0))
  ;(princ (strcat "Fcall steht auf " fcallstring))
  (setq Bauteilnr (strcase (getstring "\nBauteil-Nr: ")))
  (setq Bauteilart (strcase (getstring "\nBauteil-Art: RE/L/U/K:")))
  (setq ptBauteil (getpoint "\nBT-Text Insertion Point")) 
  (command "text" ptBauteil "0" (strcat Bauteilnr " " Bauteilart))

  
  ;writing IxoSA,IyoSA... in dtext
  (setq pttext (getpoint "\nI_y,I_z TEXT Insertion Point")) 	;Till
   
  (setq xsys (strcat (rtos xs 2 6) " ;" (rtos ys 2 6) " ;" (rtos Area 2 4))) 
  (setq IxIyIxy (strcat (rtos IxoSA 2 6) " ;" (rtos IyoSA 2 6) " ;" (rtos IxyoSA 2 6)))   ;rtos Zahl 2 (f�r Dezimale Darstellung) 3 (Anzahl d. Stellen) Strings zu einer Stringkette
  
  (command "text" pttext "0" (strcat Bauteilnr " ;" Bauteilart " ;Ix/Iy/Ixy/xs/ys/Area; " IxIyIxy " ;" xsys))            ; todo option, xsys...  in neue Zeile packen !!

  (princ (strcat "\narea= " (rtos Area 2 4)))
  ;(princ (strcat "\nFcall steht auf " fcallstring))
  (print (strcat "\n pt koord." (rtos pt 2 4)))
  (print)
    			; strcat verbindet 2 oder mehr Zeichenketten 
  ) ;end defun

;set fltcall to manual value
(defun c:setfcall () (setq fcall (getint "\nfcall: "))
  (princ)) 

(prompt "\n < flt > eingeben zum Starten ,Schriftstil mit Texth�he vorher einstellen !!!
	\n\nFLT berechnet:
	\n- Fl�chentr�gheitsmomente Ix,Iy, Ixy (ohne Steiner Anteil)
	\n- Schwerpunkte x_s, y_s beliebiger Fl�chen.
	\n \n Berechnung �ber masseig-Befehl. Export der Zeilen der masseig-file in dtext, dtext in ZEichnung
	ablegen. text mit textout.lsp exportieren
	\n\nF�r Aussteifungsberechnung mit iMath und CALC,
	\nmit BKS KO-System verschieben, CSV.lisp als CSV-Datei abspeichern") 



  

;|�Visual LISP� Format Options� (72 2 40 1 nil "end of " 60 9 0 0 0 T T nil T) 
 ***Don't add text below the comment!***|;  