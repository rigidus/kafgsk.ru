(let ((files '("01.07.12.html" "01.09.12.html" "25.06.12.html" "arhiv2012.html" "arhiv2013.html" "arhiv.html" "aspirantura.html" "contacts.html" "diplomy.html" "foto.html" "history.html" "index.html" "lab2009.html" "praktika.html" "pr_doc.html" "predmety.html" "prepody.html" "pr_etap1.html" "pr_etap2.html" "pr_raspr2012.html" "pr_spisorg.html" "pr_sroki.html" "pr_vidy.html" "pr_zayavka.html" "raspisanie.html" "template.html")))
  (loop :for file :in files :do
     (let* ((content (alexandria:read-file-into-string file))
            (pos     (search "<div class=\"content\">" content))
            (new-content (subseq content (+ 21 pos))))
       (alexandria:write-string-into-file
        new-content
        (subseq file 0 (- (length file) 1))
        :if-exists :supersede))))

