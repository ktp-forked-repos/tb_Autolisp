; Z�hlfunktion Tb
;


(defun c:z�hler ()

(setq Nr 1)
(if Nr (1+ Nr ) 1)

  (setq Wort (getstring "\nWort: "))
  
	;(alert (strcat "Z�hler steht auf " (rtos Zaehler 2 0)))

  (princ (strcat "z�hler steht auf " (rtos Nr 2 0)))

  (princ (strcat "\nBauteil:" Wort))
(princ)
);_defun
