
;;;======================================================
;;;   Computer Expert System
;;;
;;;     This expert system diagnoses some simple
;;;     problems with a computer.
;;;
;;;     CLIPS Version 6.3 
;;;
;;;     To execute, merely load, reset and run.
;;;======================================================

;;****************
;;* DEFFUNCTIONS *
;;****************

(deffunction ask-question (?question $?allowed-values)
   (printout t ?question)
   (bind ?answer (read))
   (if (lexemep ?answer) 
       then (bind ?answer (lowcase ?answer)))
   (while (not (member ?answer ?allowed-values)) do
      (printout t ?question)
      (bind ?answer (read))
      (if (lexemep ?answer) 
          then (bind ?answer (lowcase ?answer))))
   ?answer)

(deffunction yes-or-no-p (?question)
   (bind ?response (ask-question ?question yes no y n))
   (if (or (eq ?response yes) (eq ?response y))
       then yes 
       else no))

;;;***************
;;;* QUERY RULES *
;;;***************
;;; komputer menyala

(defrule determine-computer-state ""
   (not (komputer-hidup ?))
   (not (repair ?))
   =>
   (assert (komputer-hidup (yes-or-no-p "Apakah komputer menyala saat tombol power ditekan (yes/no)? "))))

(defrule determine-booting ""
   (komputer-hidup yes)
   (not (repair ?))
   =>
   (assert (booting-start (yes-or-no-p "Apakah booting komputer berjalan (yes/no)? "))))

(defrule determine-booting-normal ""
    (komputer-hidup yes)
	(not (repair ?))
   =>
   (assert (booting-normally (yes-or-no-p "Apakah booting komputer berjalan normal(yes/no)? "))))

(defrule determine-aplikasi ""
   (komputer-hidup yes)
	(not (repair ?))
   =>
   (assert (jalankan-aplikasi (yes-or-no-p "Apakah saat menjalankan aplikasi berjalan normal(yes/no)? "))))

(defrule determine-kabel-power ""
   (komputer-hidup no)
   (not (repair ?))
   =>
   (assert (kabel-putus (yes-or-no-p "Apakah kabel power komputer putus (yes/no)? "))))
 
 (defrule determine-power-supply ""
   (komputer-hidup no)
   (not (repair ?))
   =>
   (assert (power-supply (yes-or-no-p "Apakah power supply menyala (yes/no)? "))))


;;;****************
;;;* REPAIR RULES *
;;;****************
(defrule komputer-baik ""
   (jalankan-aplikasi yes)
   (not (repair ?))
   =>
   (assert (repair "Komputer anda baik - baik saja.")))
   
(defrule bluescreen ""
  (jalankan-aplikasi no)
  (not (repair ?))
  =>
  (assert (repair "Uninstall aplikasi tersebut")))
  
  (defrule booting-berulang ""
  (booting-normally no)
  (not (repair ?))
  =>
  (assert (repair "RAM anda bermasalah, silahkan segera anda ganti ")))

  (defrule tidak-booting ""
  (booting-start no)
  (not (repair ?))
  =>
  (assert (repair "Hardisk anda bermasalah, silahkan segera anda ganti ")))
	
	
  (defrule kabel-power-putus ""
  (kabel-putus yes)
  (not (repair ?))
  =>
  (assert (repair "Ganti kabel power komputer anda")))
  
  (defrule power-supply-mati ""
  (power-supply no)
  (not (repair ?))
  =>
  (assert (repair "Power supply komputer anda bermasalah, silahkan segera anda ganti ")))
  
  (defrule power-supply-hidup ""
  (power-supply yes)
  (not (repair ?))
  =>
  (assert (repair "Motherbboard anda anda bermasalah, silahkan segera anda ganti ")))

(defrule no-repairs ""
  (declare (salience -10))
  (not (repair ?))
  =>
  (assert (repair "Take your computer to a mechanic.")))

;;;********************************
;;;* STARTUP AND CONCLUSION RULES *
;;;********************************

(defrule system-banner ""
  (declare (salience 10))
  =>
  (printout t crlf crlf)
  (printout t "The Engine Diagnosis Expert System")
  (printout t crlf crlf))

(defrule print-repair ""
  (declare (salience 10))
  (repair ?item)
  =>
  (printout t crlf crlf)
  (printout t "Suggested Repair:")
  (printout t crlf crlf)
  (format t " %s%n%n%n" ?item))

