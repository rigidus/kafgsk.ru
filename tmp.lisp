(in-package #:kafgsk)

;; (let ((files '("01.07.12.html" "01.09.12.html" "25.06.12.html" "arhiv2012.html" "arhiv2013.html" "arhiv.html" "aspirantura.html" "contacts.html" "diplomy.html" "foto.html" "history.html" "index.html" "lab2009.html" "praktika.html" "pr_doc.html" "predmety.html" "prepody.html" "pr_etap1.html" "pr_etap2.html" "pr_raspr2012.html" "pr_spisorg.html" "pr_sroki.html" "pr_vidy.html" "pr_zayavka.html" "raspisanie.html" "template.html")))
;;   (loop :for file :in files :do
;;      (let* ((content (alexandria:read-file-into-string file))
;;             (pos     (search "<div class=\"content\">" content))
;;             (new-content (subseq content (+ 21 pos))))
;;        (alexandria:write-string-into-file
;;         new-content
;;         (subseq file 0 (- (length file) 1))
;;         :if-exists :supersede))))

(defclass teacher ()
  ((name :initarg :name :accessor name)
   (kurs :initarg :kurs :accessor kurs)
   (rank :initarg :rank :accessor rank)))

(defparameter *teachers* (make-hash-table :test #'equal))

(setf (gethash 1 *teachers*)
      (make-instance 'teacher
                     :name "Моргунов Константин Петрович"
                     :kurs (list "курс-1" "курс-2" "курс-3")
                     :rank "доцент, к.т.н."))


(setf (gethash 2 *teachers*)
      (make-instance 'teacher
                     :name "Гапеев Анатолий Михайлович"
                     :kurs (list  "курс-4" "курс-5")
                     :rank "профессор, д.т.н."))

(let ((result))
  (maphash #'(lambda (k v)
               (when (find "курс-1" (kurs v) :test #'string=)
                 (push (name v) result)))
           *teachers*)
  (print result))


(rank (gethash 2 *teachers*))



