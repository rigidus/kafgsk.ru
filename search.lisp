(in-package #:kafgsk)

;; инициализировать очередь страниц
;; добавить в очередь главную страницу сайта

;; @ для каждого урла страницы
;; загрузить адрес текущей страницы из очереди
;; загрузить страницу по этому адресу
;; найти все ссылки
;; если ссылка локальная - добавить в очередь, иначе - добавить в список внешних ссылок страницы

;; @ для каждой загруженной страницы
;; исключить общие элементы (дизайн, меню и;; т;; п;; ), очистить содержимое
;; построить прямой индекс
;; построить обратный индекс
;; tf:idf

(defun recur-files (path)
  ;; получаем список файлов и поддиректорий
  (let ((files (directory (merge-pathnames path "*.*")))
        (dirs  (directory (merge-pathnames path "*"))))
    (setf files (remove-if #'(lambda (x)
                               (find x dirs :test #'(lambda (a b)
                                                      (string= (format nil "~A" a)
                                                               (format nil "~A" b)))))
                           files))
    ;; для каждой поддиректории:
    (loop :for dir :in dirs :do
       ;; рекурсивно вызываем себя
       (setf files (append files (recur-files dir))))
    ;; возвращаем результат
    files))

(defun get-all-pages (path)
  (let ((all-files (recur-files path)))
    (loop :for file :in all-files :collect
       (list (format nil "~A" file)
             (alexandria:read-file-into-string file)))))

(defun get-search-words (search-query)
  (split-sequence:split-sequence #\Space search-query))


(defun search-word-in-page (word page)
  (search word page :test #'string=))


(defun search-in-pages (search-query pages)
  ;; разбить поисковый запрос на слова
  (let ((results nil)
        (words (get-search-words search-query)))
    (loop :for word :in words :do
       ;; для каждого слова: взять все страницы
       (loop :for (file page) :in pages :do
          ;; для каждой страницы: искать слово
          (if (search-word-in-page word page)
              ;; если слово найдено - добавить в результаты
              (push file results))))
    (remove-duplicates results)))

(search-in-pages "факультет информационных технологий" (get-all-pages (path "content/")))

;; TODO
;; Приводить слово к нормальной форме (отрезать окончания)
;; Оценивать релевантность
;; Выводить сниппет
