GA ist �hnlich wie PickAREA
(Fl�chenbestimmung mit tempor�rer Erstellung von Hatches)
 nur mit textausgabe!!



(defun C:flaechetxt()(/ flae umf)

	(setq pt(getpoint)
	(command "_pickarea" pt)
	
	(setq flae(getvar "_area")
	(setq umf(getvar "_perimeter")
	